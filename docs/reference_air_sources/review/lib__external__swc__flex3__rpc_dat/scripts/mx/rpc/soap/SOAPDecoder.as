package mx.rpc.soap
{
   import flash.utils.getTimer;
   import flash.xml.XMLDocument;
   import flash.xml.XMLNode;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.rpc.soap.types.ICustomSOAPType;
   import mx.rpc.wsdl.WSDLEncoding;
   import mx.rpc.wsdl.WSDLMessagePart;
   import mx.rpc.wsdl.WSDLOperation;
   import mx.rpc.xml.ContentProxy;
   import mx.rpc.xml.DecodingContext;
   import mx.rpc.xml.SchemaConstants;
   import mx.rpc.xml.SchemaDatatypes;
   import mx.rpc.xml.TypeIterator;
   import mx.rpc.xml.XMLDecoder;
   import mx.utils.StringUtil;
   import mx.utils.URLUtil;
   import mx.utils.XMLUtil;
   
   [ExcludeClass]
   public class SOAPDecoder extends XMLDecoder implements ISOAPDecoder
   {
      
      public static var PI_WHITESPACE_PATTERN:RegExp = /[\?][>]\s*[<]/g;
      
      private var _multiplePartsFormat:String;
      
      private var _forcePartArrays:Boolean;
      
      private var _headerFormat:String;
      
      private var log:ILogger;
      
      private var _resultFormat:String;
      
      private var _ignoreWhitespace:Boolean = true;
      
      private var _referencesResolved:Boolean;
      
      public var supportGenericCompoundTypes:Boolean = false;
      
      private var _wsdlOperation:WSDLOperation;
      
      private var _elementsWithId:XMLList;
      
      public function SOAPDecoder()
      {
         super();
         log = Log.getLogger("mx.rpc.soap.SOAPDecoder");
      }
      
      public function get soapConstants() : SOAPConstants
      {
         return wsdlOperation.soapConstants;
      }
      
      override public function decodeComplexRestriction(restriction:XML, parent:*, name:QName, value:*) : void
      {
         var customType:ICustomSOAPType = null;
         var schemaConstants:SchemaConstants = schemaManager.schemaConstants;
         var baseName:String = restriction.@base;
         var baseQName:QName = schemaManager.getQNameForPrefixedName(baseName,restriction);
         if(baseQName == soapConstants.soapencArrayQName)
         {
            customType = SOAPConstants.getCustomSOAPType(baseQName);
            if(customType != null)
            {
               customType.decode(this,parent,name,value,restriction);
               return;
            }
         }
         super.decodeComplexRestriction(restriction,parent,name,value);
      }
      
      public function set multiplePartsFormat(value:String) : void
      {
         _multiplePartsFormat = value;
      }
      
      override protected function isInternalNamespace(name:QName) : Boolean
      {
         var uri:String = name != null ? name.uri : null;
         if(Boolean(uri))
         {
            if(URLUtil.urisEqual(uri,soapConstants.encodingURI) || URLUtil.urisEqual(uri,soapConstants.envelopeURI))
            {
               return true;
            }
         }
         return super.isInternalNamespace(name);
      }
      
      private function resolveReferences(root:XML, cleanupElementsWithIdCache:Boolean = true) : void
      {
         var index:uint;
         var child:XML = null;
         var href:String = null;
         var hashPosition:int = 0;
         var matches:XMLList = null;
         var referent:XML = null;
         if(_referencesResolved)
         {
            return;
         }
         index = 0;
         if(_elementsWithId == null)
         {
            _elementsWithId = document..*.(attribute("id").length() > 0);
         }
         for each(child in root.children())
         {
            if(child.nodeKind() == "element")
            {
               href = getAttributeFromNode("href",child);
               if(href != null)
               {
                  hashPosition = href.indexOf("#");
                  if(hashPosition >= 0)
                  {
                     href = href.substring(hashPosition + 1);
                  }
                  matches = _elementsWithId.(@id == href);
                  if(matches.length() <= 0)
                  {
                     throw new Error("The element referenced by id \'" + href + "\' was not found.");
                  }
                  referent = matches[0];
                  referent.setName(child.name());
                  if(referent.hasComplexContent())
                  {
                     resolveReferences(referent,false);
                  }
                  root.replace(index,referent);
                  referent = root.child(index)[0];
                  delete referent.@id;
               }
               else if(child.hasComplexContent())
               {
                  resolveReferences(child,false);
               }
            }
            index++;
         }
         if(cleanupElementsWithIdCache)
         {
            _elementsWithId = null;
            _referencesResolved = true;
         }
      }
      
      protected function decodeFaults(faultsXMLList:XMLList) : Array
      {
         var faultXML:XML = null;
         var code:QName = null;
         var string:String = null;
         var detail:String = null;
         var element:XML = null;
         var actor:String = null;
         var faultProperties:XMLList = null;
         var child:XML = null;
         var fault:SOAPFault = null;
         log.debug("SOAP: Decoding SOAP response fault");
         var faults:Array = [];
         for each(faultXML in faultsXMLList)
         {
            element = faultXML;
            faultProperties = faultXML.children();
            for each(child in faultProperties)
            {
               if(child.localName() == "faultcode")
               {
                  code = schemaManager.getQNameForPrefixedName(child.toString(),child);
               }
               else if(child.localName() == "faultstring")
               {
                  string = child.toString();
               }
               else if(child.localName() == "faultactor")
               {
                  actor = child.toString();
               }
               else if(child.localName() == "detail")
               {
                  if(child.hasComplexContent())
                  {
                     detail = child.children().toXMLString();
                  }
                  else
                  {
                     detail = child.toString();
                  }
               }
            }
            fault = new SOAPFault(code,string,detail,element,actor);
            faults.push(fault);
         }
         return faults;
      }
      
      override protected function preProcessXML(root:XML) : void
      {
         if(outputEncoding.useStyle == SOAPConstants.USE_ENCODED)
         {
            resolveReferences(root);
         }
      }
      
      public function get schemaConstants() : SchemaConstants
      {
         return schemaManager.schemaConstants;
      }
      
      public function set forcePartArrays(value:Boolean) : void
      {
         _forcePartArrays = value;
      }
      
      protected function decodeHeaders(headerXML:XML) : Array
      {
         var headerChild:XML = null;
         var xsiType:QName = null;
         var definition:XML = null;
         var headerContent:Object = null;
         var headerObject:SOAPHeader = null;
         var muValue:String = null;
         var actValue:String = null;
         log.debug("Decoding SOAP response headers");
         var headers:Array = [];
         var headerXMLList:XMLList = headerXML.elements();
         for each(headerChild in headerXMLList)
         {
            if(headerFormat == "object")
            {
               xsiType = getXSIType(headerChild);
               definition = null;
               headerContent = null;
               if(xsiType != null)
               {
                  definition = schemaManager.getNamedDefinition(xsiType,constants.complexTypeQName,constants.simpleTypeQName);
               }
               if(definition != null)
               {
                  schemaManager.releaseScope();
                  headerContent = decode(headerChild,null,xsiType);
               }
               else
               {
                  headerContent = decode(headerChild,headerChild.name());
               }
               headerObject = new SOAPHeader(headerChild.name(),headerContent);
               muValue = XMLUtil.getAttributeByQName(headerChild,soapConstants.mustUnderstandQName).toString();
               if(muValue == "1")
               {
                  headerObject.mustUnderstand = true;
               }
               actValue = XMLUtil.getAttributeByQName(headerChild,soapConstants.actorQName).toString();
               if(actValue != "")
               {
                  headerObject.role = actValue;
               }
               headers.push(headerObject);
            }
            else if(headerFormat == "e4x")
            {
               headers.push(headerChild);
            }
            else if(headerFormat == "xml")
            {
               headers.push(new XMLDocument(headerChild.toString()));
            }
         }
         return headers;
      }
      
      override public function decodeComplexType(definition:XML, parent:*, name:QName, value:*, restriction:XML = null, context:DecodingContext = null) : void
      {
         var valXML:XML = null;
         if(value is XML)
         {
            valXML = value as XML;
            if(valXML.elements(SOAPConstants.diffgramQName).length() > 0 && valXML.elements(schemaConstants.schemaQName).length() > 0)
            {
               decodeType(SOAPConstants.diffgramQName,parent,valXML.name(),value);
               return;
            }
         }
         super.decodeComplexType(definition,parent,name,value,restriction,context);
      }
      
      protected function get inputEncoding() : WSDLEncoding
      {
         var encoding:WSDLEncoding = null;
         if(_wsdlOperation.inputMessage != null)
         {
            encoding = _wsdlOperation.inputMessage.encoding;
         }
         else
         {
            encoding = new WSDLEncoding();
         }
         return encoding;
      }
      
      protected function decodeBody(bodyXML:XML, soapResult:SOAPResult) : void
      {
         var result:* = undefined;
         var part:WSDLMessagePart = null;
         var wrappedDefinition:XML = null;
         var encodedPartValues:XMLList = null;
         var encodedPartValue:XML = null;
         var decodedPart:* = undefined;
         var partQName:QName = null;
         var partType:QName = null;
         var partDefinition:XML = null;
         var encodedNamespace:String = null;
         var partMaxOccurs:uint = 0;
         var sinlgePartResultType:QName = null;
         var singlePartMaxOccurs:uint = 0;
         log.debug("Decoding SOAP response body");
         document = bodyXML;
         preProcessXML(bodyXML);
         if(wsdlOperation.outputMessage == null)
         {
            soapResult.result = undefined;
            return;
         }
         var parts:Array = wsdlOperation.outputMessage.parts;
         if(parts == null || parts.length == 0)
         {
            soapResult.result = undefined;
            return;
         }
         var outputMessageXML:XML = bodyXML;
         if(wsdlOperation.style == SOAPConstants.RPC_STYLE)
         {
            outputMessageXML = outputMessageXML.elements()[0];
         }
         else if(outputEncoding.useStyle == SOAPConstants.USE_LITERAL && wsdlOperation.outputMessage.isWrapped == true)
         {
            wrappedDefinition = schemaManager.getNamedDefinition(wsdlOperation.outputMessage.wrappedQName,constants.complexTypeQName,constants.elementTypeQName);
            outputMessageXML = outputMessageXML.elements()[0];
         }
         for each(part in parts)
         {
            if(part.element != null)
            {
               if(outputMessageXML.hasComplexContent())
               {
                  encodedPartValues = outputMessageXML.elements(part.element);
               }
               else
               {
                  encodedPartValues = outputMessageXML.text();
               }
               partQName = part.element;
               partType = null;
            }
            else
            {
               partType = part.type;
               partDefinition = part.definition;
               if(outputMessageXML.hasComplexContent())
               {
                  if(outputEncoding.useStyle == SOAPConstants.USE_ENCODED)
                  {
                     partQName = new QName("",part.name.localName);
                     encodedPartValues = outputMessageXML.elements(partQName);
                     if(encodedPartValues.length() == 0)
                     {
                        encodedNamespace = outputEncoding.namespaceURI;
                        partQName = new QName(encodedNamespace,part.name.localName);
                        encodedPartValues = outputMessageXML.elements(partQName);
                        if(encodedPartValues.length() == 0)
                        {
                           encodedNamespace = inputEncoding.namespaceURI;
                           partQName = new QName(encodedNamespace,part.name.localName);
                           encodedPartValues = outputMessageXML.elements(partQName);
                        }
                     }
                  }
                  else
                  {
                     encodedPartValues = outputMessageXML.elements(part.name);
                  }
               }
               else
               {
                  encodedPartValues = outputMessageXML.text();
               }
            }
            for each(encodedPartValue in encodedPartValues)
            {
               decodedPart = decode(encodedPartValue,partQName,partType,partDefinition);
               if(parts.length > 1)
               {
                  if(multiplePartsFormat == "object")
                  {
                     if(result == null)
                     {
                        result = createContent(outputMessageXML.name());
                        result.isSimple = false;
                     }
                     if(result[part.name.localName] == null)
                     {
                        partMaxOccurs = getMaxOccurs(partDefinition);
                        if(partMaxOccurs > 1 && forcePartArrays || encodedPartValues.length() > 1)
                        {
                           result[part.name.localName] = createIterableValue(part.type);
                        }
                     }
                     if(TypeIterator.isIterable(result[part.name.localName]))
                     {
                        TypeIterator.push(result[part.name.localName],decodedPart);
                     }
                     else
                     {
                        result[part.name.localName] = decodedPart;
                     }
                  }
                  else if(multiplePartsFormat == "array")
                  {
                     if(result == null)
                     {
                        result = createIterableValue(outputMessageXML.name());
                     }
                     TypeIterator.push(result,decodedPart);
                  }
               }
               else
               {
                  if(result == null)
                  {
                     sinlgePartResultType = partType;
                     if(sinlgePartResultType == null)
                     {
                        sinlgePartResultType = part.element;
                     }
                     if(sinlgePartResultType == null)
                     {
                        sinlgePartResultType = part.name;
                     }
                     singlePartMaxOccurs = getMaxOccurs(partDefinition);
                     if(singlePartMaxOccurs > 1 && forcePartArrays || encodedPartValues.length() > 1)
                     {
                        result = createIterableValue(sinlgePartResultType);
                     }
                     else
                     {
                        result = createContent();
                     }
                  }
                  if(TypeIterator.isIterable(result))
                  {
                     TypeIterator.push(result,decodedPart);
                  }
                  else
                  {
                     result = decodedPart;
                  }
               }
            }
         }
         if(result is ContentProxy)
         {
            result = ContentProxy(result).content;
         }
         soapResult.result = result;
      }
      
      public function set wsdlOperation(value:WSDLOperation) : void
      {
         _wsdlOperation = value;
         schemaManager = _wsdlOperation.schemaManager;
      }
      
      public function get multiplePartsFormat() : String
      {
         return _multiplePartsFormat;
      }
      
      public function set headerFormat(value:String) : void
      {
         _headerFormat = value;
      }
      
      public function decodeResponse(response:*) : SOAPResult
      {
         var startTime:int;
         var soapResult:SOAPResult = null;
         var responseString:String = null;
         var oldIgnoreWhitespace:Boolean = false;
         var responseXML:XML = null;
         if(response is XML)
         {
            responseString = XML(response).toXMLString();
         }
         else
         {
            responseString = String(response);
         }
         startTime = getTimer();
         log.info("Decoding SOAP response");
         reset();
         if(responseString != null)
         {
            log.debug("Encoded SOAP response {0}",responseString);
            oldIgnoreWhitespace = Boolean(XML.ignoreWhitespace);
            try
            {
               responseString = responseString.replace(PI_WHITESPACE_PATTERN,"?><");
               responseString = StringUtil.trim(responseString);
               XML.ignoreWhitespace = ignoreWhitespace;
               responseXML = new XML(responseString);
               soapResult = decodeEnvelope(responseXML);
            }
            finally
            {
               XML.ignoreWhitespace = oldIgnoreWhitespace;
            }
         }
         log.info("Decoded SOAP response into result [{0} millis]",getTimer() - startTime);
         return soapResult;
      }
      
      override public function decodeType(type:QName, parent:*, name:QName, value:*, restriction:XML = null) : void
      {
         var datatypes:SchemaDatatypes = null;
         var localName:String = null;
         var constants:SchemaConstants = null;
         var definition:XML = null;
         var originalType:QName = type;
         var xsiType:QName = getXSIType(value);
         if(xsiType != null)
         {
            type = xsiType;
         }
         if(outputEncoding.useStyle == SOAPConstants.USE_ENCODED)
         {
            if(SOAPConstants.isSOAPEncodedType(type))
            {
               datatypes = schemaManager.schemaDatatypes;
               if(type == soapConstants.soapBase64QName)
               {
                  type = datatypes.base64BinaryQName;
               }
               else
               {
                  localName = type.localName;
                  if(localName != "Array" && localName != "arrayType")
                  {
                     type = schemaConstants.getQName(localName);
                  }
               }
            }
         }
         var customType:ICustomSOAPType = SOAPConstants.getCustomSOAPType(type);
         if(customType != null)
         {
            customType.decode(this,parent,name,value,restriction);
            setXSIType(parent,type);
         }
         else
         {
            constants = schemaManager.schemaConstants;
            if(isBuiltInType(type))
            {
               super.decodeType(type,parent,name,value,restriction);
            }
            else
            {
               definition = schemaManager.getNamedDefinition(type,constants.complexTypeQName,constants.simpleTypeQName,constants.elementTypeQName);
               if(definition != null)
               {
                  schemaManager.releaseScope();
                  super.decodeType(type,parent,name,value,restriction);
               }
               else
               {
                  super.decodeType(originalType,parent,name,value,restriction);
               }
            }
         }
      }
      
      public function get forcePartArrays() : Boolean
      {
         return _forcePartArrays;
      }
      
      public function set ignoreWhitespace(value:Boolean) : void
      {
         _ignoreWhitespace = value;
      }
      
      public function get wsdlOperation() : WSDLOperation
      {
         return _wsdlOperation;
      }
      
      public function get headerFormat() : String
      {
         return _headerFormat;
      }
      
      public function set resultFormat(value:String) : void
      {
         _resultFormat = value;
      }
      
      protected function decodeEnvelope(responseXML:XML) : SOAPResult
      {
         var envNS:Namespace = null;
         var schemaConst:SchemaConstants = null;
         var nsArray:Array = null;
         var ns:Namespace = null;
         var headerXML:XML = null;
         var bodyXML:XML = null;
         var faultXMLList:XMLList = null;
         var bodyArray:Array = null;
         var bodyXMLList:XMLList = null;
         var bodyChild:XML = null;
         var nodeKind:String = null;
         var xmlDoc:XMLDocument = null;
         var xmlNode:XMLNode = null;
         log.debug("Decoding SOAP response envelope");
         var soapResult:SOAPResult = new SOAPResult();
         if(responseXML != null)
         {
            envNS = responseXML.namespace();
         }
         if(envNS == null)
         {
            throw new Error("SOAP Response cannot be decoded. Raw response: " + responseXML);
         }
         if(envNS.uri != SOAPConstants.SOAP_ENVELOPE_URI)
         {
            throw new Error("SOAP Response Version Mismatch");
         }
         nsArray = responseXML.inScopeNamespaces();
         for each(ns in nsArray)
         {
            schemaManager.namespaces[ns.prefix] = ns;
         }
         headerXML = responseXML[soapConstants.headerQName][0];
         if(headerXML != null)
         {
            soapResult.headers = decodeHeaders(headerXML);
         }
         bodyXML = responseXML[soapConstants.bodyQName][0];
         if(bodyXML == null || bodyXML.hasComplexContent() == false || bodyXML.children().length() <= 0)
         {
            soapResult.result = undefined;
         }
         else
         {
            faultXMLList = bodyXML[soapConstants.faultQName];
            if(faultXMLList.length() > 0)
            {
               soapResult.isFault = true;
               soapResult.result = decodeFaults(faultXMLList);
            }
            else if(resultFormat == "object")
            {
               decodeBody(bodyXML,soapResult);
            }
            else if(resultFormat == "e4x")
            {
               soapResult.result = bodyXML.children();
            }
            else if(resultFormat == "xml")
            {
               bodyArray = [];
               bodyXMLList = bodyXML.children();
               for each(bodyChild in bodyXMLList)
               {
                  nodeKind = bodyChild.nodeKind();
                  if(nodeKind == "element")
                  {
                     xmlDoc = new XMLDocument(bodyChild.toString());
                     xmlNode = xmlDoc.firstChild;
                     bodyArray.push(xmlNode);
                  }
                  else if(nodeKind == "text")
                  {
                     bodyArray.push(bodyChild.toString());
                  }
               }
               soapResult.result = bodyArray;
            }
         }
         return soapResult;
      }
      
      override public function reset() : void
      {
         super.reset();
         _referencesResolved = false;
         _elementsWithId = null;
      }
      
      protected function get outputEncoding() : WSDLEncoding
      {
         var encoding:WSDLEncoding = null;
         if(_wsdlOperation.outputMessage != null)
         {
            encoding = _wsdlOperation.outputMessage.encoding;
         }
         else
         {
            encoding = new WSDLEncoding();
         }
         return encoding;
      }
      
      public function get ignoreWhitespace() : Boolean
      {
         return _ignoreWhitespace;
      }
      
      public function get resultFormat() : String
      {
         return _resultFormat;
      }
      
      override protected function parseValue(name:*, value:XMLList) : *
      {
         var itemQName:QName = null;
         var items:XMLList = null;
         if(supportGenericCompoundTypes && outputEncoding.useStyle == SOAPConstants.USE_LITERAL && value.length() > 0)
         {
            itemQName = new QName(value[0].name().uri,"item");
            items = value.elements(itemQName);
            if(items.length() > 0)
            {
               value = items;
            }
         }
         return super.parseValue(name,value);
      }
   }
}

