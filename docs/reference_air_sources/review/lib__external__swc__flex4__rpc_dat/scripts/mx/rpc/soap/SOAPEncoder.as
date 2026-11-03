package mx.rpc.soap
{
   import flash.xml.XMLDocument;
   import flash.xml.XMLNode;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import mx.rpc.soap.types.ICustomSOAPType;
   import mx.rpc.wsdl.WSDLEncoding;
   import mx.rpc.wsdl.WSDLMessagePart;
   import mx.rpc.wsdl.WSDLOperation;
   import mx.rpc.xml.SchemaConstants;
   import mx.rpc.xml.SchemaDatatypes;
   import mx.rpc.xml.SchemaMarshaller;
   import mx.rpc.xml.XMLEncoder;
   
   [ExcludeClass]
   [ResourceBundle("rpc")]
   public class SOAPEncoder extends XMLEncoder implements ISOAPEncoder
   {
      
      private var resourceManager:IResourceManager = ResourceManager.getInstance();
      
      private var _ignoreWhitespace:Boolean = true;
      
      private var isSOAPEncoding:Boolean = false;
      
      private var log:ILogger;
      
      private var _wsdlOperation:WSDLOperation;
      
      public function SOAPEncoder()
      {
         super();
         this.log = Log.getLogger("mx.rpc.soap.SOAPEncoder");
      }
      
      public function get ignoreWhitespace() : Boolean
      {
         return this._ignoreWhitespace;
      }
      
      public function set ignoreWhitespace(value:Boolean) : void
      {
         this._ignoreWhitespace = value;
      }
      
      protected function get inputEncoding() : WSDLEncoding
      {
         return this._wsdlOperation.inputMessage.encoding;
      }
      
      public function get schemaConstants() : SchemaConstants
      {
         return schemaManager.schemaConstants;
      }
      
      public function get soapConstants() : SOAPConstants
      {
         return this.wsdlOperation.soapConstants;
      }
      
      public function get wsdlOperation() : WSDLOperation
      {
         return this._wsdlOperation;
      }
      
      public function set wsdlOperation(value:WSDLOperation) : void
      {
         this._wsdlOperation = value;
         schemaManager = this._wsdlOperation.schemaManager;
      }
      
      public function encodeRequest(args:* = null, headers:Array = null) : XML
      {
         var oldIgnoreWhitespace:Boolean;
         var oldPrettyPrinting:Boolean;
         var envelopeXML:XML = null;
         reset();
         oldIgnoreWhitespace = Boolean(XML.ignoreWhitespace);
         oldPrettyPrinting = Boolean(XML.prettyPrinting);
         try
         {
            XML.ignoreWhitespace = this.ignoreWhitespace;
            XML.prettyPrinting = false;
            envelopeXML = this.encodeEnvelope(args,headers);
         }
         finally
         {
            XML.ignoreWhitespace = oldIgnoreWhitespace;
            XML.prettyPrinting = oldPrettyPrinting;
         }
         return envelopeXML;
      }
      
      protected function encodeEnvelope(args:*, headers:Array) : XML
      {
         this.log.debug("Encoding SOAP request envelope");
         var envelopeXML:XML = new XML("<" + this.soapConstants.envelopeQName.localName + "/>");
         envelopeXML.setNamespace(this.soapConstants.envelopeNamespace);
         envelopeXML.addNamespace(this.schemaConstants.xsdNamespace);
         envelopeXML.addNamespace(this.schemaConstants.xsiNamespace);
         schemaManager.namespaces[this.soapConstants.envelopeNamespace.prefix] = this.soapConstants.envelopeNamespace;
         this.encodeHeaders(headers,envelopeXML);
         this.encodeBody(args,envelopeXML);
         return envelopeXML;
      }
      
      protected function encodeHeaders(headers:Array, envelopeXML:XML) : void
      {
         var count:uint = 0;
         var headersXML:XML = null;
         var i:uint = 0;
         if(headers != null)
         {
            count = headers.length;
            if(count > 0)
            {
               headersXML = new XML("<" + this.soapConstants.headerQName.localName + "/>");
               headersXML.setNamespace(this.soapConstants.envelopeNamespace);
               envelopeXML.appendChild(headersXML);
               for(i = 0; i < count; i++)
               {
                  this.encodeHeaderElement(headers[i],headersXML);
               }
            }
         }
      }
      
      protected function encodeHeaderElement(header:Object, headersXML:XML) : void
      {
         var headerElement:XMLList = null;
         var headerElementNode:XML = null;
         var attrStr:String = null;
         var prefix:String = null;
         var ns:Namespace = null;
         var preEncodedNode:* = this.preEncodedCheck(header);
         if(preEncodedNode != null)
         {
            headersXML.appendChild(header);
         }
         else
         {
            headerElement = new XMLList();
            if(header.content != null && Boolean(header.content.hasOwnProperty(header.qname.localName)))
            {
               header.content = header.content[header.qname.localName];
            }
            preEncodedNode = this.preEncodedCheck(header.content);
            if(preEncodedNode != null)
            {
               if(preEncodedNode is XMLList)
               {
                  headerElement = preEncodedNode as XMLList;
               }
               else
               {
                  headerElement = new XMLList(preEncodedNode);
               }
            }
            else
            {
               headerElement = this.encode(header.content,header.qname);
            }
            for each(headerElementNode in headerElement)
            {
               if(header.qname.uri != null && header.qname.uri.length > 0 && headerElementNode.namespace().uri != header.qname.uri)
               {
                  prefix = schemaManager.getOrCreatePrefix(header.qname.uri);
                  ns = new Namespace(prefix,header.qname.uri);
                  headerElementNode.setNamespace(ns);
               }
               if(Boolean(header.mustUnderstand))
               {
                  attrStr = schemaManager.getOrCreatePrefix(this.soapConstants.mustUnderstandQName.uri);
                  headerElementNode[attrStr + ":" + this.soapConstants.mustUnderstandQName.localName] = "1";
               }
               if(header.role != null)
               {
                  attrStr = schemaManager.getOrCreatePrefix(this.soapConstants.actorQName.uri);
                  headerElementNode[attrStr + ":" + this.soapConstants.actorQName.localName] = header.role;
               }
            }
            headersXML.appendChild(headerElement);
         }
      }
      
      protected function encodeBody(inputParams:*, envelopeXML:XML) : void
      {
         this.log.debug("Encoding SOAP request body");
         var bodyXML:XML = new XML("<" + this.soapConstants.bodyQName.localName + "/>");
         bodyXML.setNamespace(this.soapConstants.envelopeNamespace);
         var preEncoded:Object = this.preEncodedCheck(inputParams);
         if(preEncoded != null)
         {
            bodyXML.appendChild(preEncoded);
         }
         else if(this.wsdlOperation.style == SOAPConstants.DOC_STYLE)
         {
            if(this.inputEncoding.useStyle != SOAPConstants.USE_LITERAL)
            {
               throw new Error("WSDL 1.1 supports operations with binding style \'document\' only if use style is \'literal\'.");
            }
            this.encodeOperationAsDocumentLiteral(inputParams,bodyXML);
         }
         else
         {
            if(this.wsdlOperation.style != SOAPConstants.RPC_STYLE)
            {
               throw new Error("Unrecognized binding style \'" + this.wsdlOperation.style + "\'. Only \'document\' and \'rpc\' styles are supported.");
            }
            if(this.inputEncoding.useStyle == SOAPConstants.USE_LITERAL)
            {
               this.encodeOperationAsRPCLiteral(inputParams,bodyXML);
            }
            else
            {
               if(this.inputEncoding.useStyle != SOAPConstants.USE_ENCODED)
               {
                  throw new Error("WSDL 1.1 does not support operations with binding style \'rpc\' and use style " + this.inputEncoding.useStyle + ".");
               }
               this.encodeOperationAsRPCEncoded(inputParams,bodyXML);
            }
         }
         envelopeXML.appendChild(bodyXML);
      }
      
      protected function encodeOperationAsDocumentLiteral(inputParams:Object, bodyXML:XML) : void
      {
         var wrappedQName:QName = null;
         var operationXML:XML = null;
         var prefix:String = null;
         var inputNamespace:Namespace = null;
         var parts:Array = this.wsdlOperation.inputMessage.parts;
         if(this.wsdlOperation.inputMessage.isWrapped)
         {
            wrappedQName = this.wsdlOperation.inputMessage.wrappedQName;
            operationXML = new XML("<" + wrappedQName.localName + "/>");
            if(wrappedQName.uri != null && wrappedQName.uri != "")
            {
               prefix = schemaManager.getOrCreatePrefix(wrappedQName.uri);
               inputNamespace = new Namespace(prefix,wrappedQName.uri);
               operationXML.setNamespace(inputNamespace);
            }
            this.encodeMessage(inputParams,operationXML);
            bodyXML.appendChild(operationXML);
         }
         else
         {
            this.encodeMessage(inputParams,bodyXML);
         }
      }
      
      protected function encodeOperationAsRPCLiteral(inputParams:Object, bodyXML:XML) : void
      {
         var operationXML:XML = new XML("<" + this.wsdlOperation.name + "/>");
         var prefix:String = schemaManager.getOrCreatePrefix(this.inputEncoding.namespaceURI);
         var ns:Namespace = new Namespace(prefix,this.inputEncoding.namespaceURI);
         operationXML.setNamespace(ns);
         this.encodeMessage(inputParams,operationXML);
         bodyXML.appendChild(operationXML);
      }
      
      protected function encodeOperationAsRPCEncoded(inputParams:*, bodyXML:XML) : void
      {
         this.isSOAPEncoding = true;
         var operationXML:XML = new XML("<" + this.wsdlOperation.name + "/>");
         var inputNamespaceURI:String = this.inputEncoding.namespaceURI;
         var inputPrefix:String = schemaManager.getOrCreatePrefix(inputNamespaceURI);
         var inputNamespace:Namespace = new Namespace(inputPrefix,inputNamespaceURI);
         operationXML.setNamespace(inputNamespace);
         this.encodeMessage(inputParams,operationXML);
         bodyXML.appendChild(operationXML);
         bodyXML[SOAPConstants.SOAP_ENV_PREFIX + ":encodingStyle"] = this.soapConstants.encodingURI;
      }
      
      protected function encodeMessage(inputParams:*, operationXML:XML) : void
      {
         var parts:Array = null;
         var message:String = null;
         var part:WSDLMessagePart = null;
         var value:* = undefined;
         var name:String = null;
         var partXMLList:XMLList = null;
         var inName:String = null;
         if(this.wsdlOperation.inputMessage != null)
         {
            parts = this.wsdlOperation.inputMessage.parts;
         }
         if(parts == null)
         {
            return;
         }
         var partNames:Object = {};
         var optionalOmitted:int = 0;
         for(var i:uint = 0; i < parts.length; i++)
         {
            part = parts[i];
            value = undefined;
            if(inputParams is Array)
            {
               value = inputParams[i];
               if(value === undefined)
               {
                  if(!part.optional)
                  {
                     message = this.resourceManager.getString("rpc","missingInputParameter",[i]);
                     throw new Error(message);
                  }
                  optionalOmitted++;
               }
            }
            else
            {
               name = part.name.localName;
               if(inputParams != null)
               {
                  value = inputParams[name];
               }
               partNames[name] = value;
               if(value === undefined || inputParams != null && !inputParams.hasOwnProperty(name))
               {
                  if(!part.optional)
                  {
                     message = this.resourceManager.getString("rpc","missingInputParameterWithName",[name]);
                     throw new Error(message);
                  }
                  optionalOmitted++;
               }
            }
            if(value !== undefined)
            {
               partXMLList = this.encodePartValue(part,value);
               operationXML.appendChild(partXMLList);
            }
         }
         if(inputParams != null)
         {
            if(inputParams is Array)
            {
               if(inputParams.length < parts.length - optionalOmitted)
               {
                  message = this.resourceManager.getString("rpc","tooFewInputParameters",[parts.length,inputParams.length]);
                  throw new Error(message);
               }
            }
            else
            {
               for(inName in inputParams)
               {
                  if(!partNames.hasOwnProperty(inName))
                  {
                     message = this.resourceManager.getString("rpc","unexpectedInputParameter",[inName]);
                     throw new Error(message);
                  }
               }
            }
         }
      }
      
      protected function encodePartValue(part:WSDLMessagePart, value:*) : XMLList
      {
         var partXMLList:XMLList = null;
         if(part.element != null)
         {
            partXMLList = this.encode(value,part.element);
         }
         else
         {
            partXMLList = this.encode(value,part.name,part.type,part.definition);
         }
         return partXMLList;
      }
      
      protected function preEncodedCheck(value:*) : Object
      {
         var xmlDocument:XMLDocument = null;
         var xmlNode:XMLNode = null;
         var preEncodedNode:Object = null;
         if(value != null)
         {
            if(value is XMLList)
            {
               preEncodedNode = value as XMLList;
            }
            else if(value is XML)
            {
               preEncodedNode = value as XML;
            }
            else if(value is XMLDocument)
            {
               xmlDocument = value as XMLDocument;
               preEncodedNode = new XML(xmlDocument.firstChild.toString());
            }
            else if(value is XMLNode)
            {
               xmlNode = value as XMLNode;
               preEncodedNode = new XML(xmlNode.toString());
            }
         }
         return preEncodedNode;
      }
      
      override public function encode(value:*, name:QName = null, type:QName = null, definition:XML = null) : XMLList
      {
         var result:XMLList = null;
         var maxOccurs:uint = 0;
         var minOccurs:uint = 0;
         var content:XMLList = null;
         var foundScope:Boolean = false;
         if(definition != null)
         {
            result = new XMLList();
            maxOccurs = getMaxOccurs(definition);
            minOccurs = getMinOccurs(definition);
            if(maxOccurs == 0)
            {
               return result;
            }
            if(value == null && minOccurs == 0)
            {
               return result;
            }
            if(maxOccurs > 1)
            {
               content = new XMLList();
               foundScope = schemaManager.pushNamespaceInScope(name.uri);
               encodeGroupElement(definition,content,name,value);
               if(foundScope)
               {
                  schemaManager.releaseScope();
               }
               return result + content;
            }
         }
         return super.encode(value,name,type,definition);
      }
      
      override public function encodeType(type:QName, parent:XML, name:QName, value:*, restriction:XML = null) : void
      {
         var localName:String = null;
         var xsiTypeAttr:String = null;
         var datatypes:SchemaDatatypes = schemaManager.schemaDatatypes;
         var xsiType:QName = getXSIType(value);
         if(xsiType != null)
         {
            type = xsiType;
         }
         if(this.isSOAPEncoding)
         {
            xsiType = type;
            if(SOAPConstants.isSOAPEncodedType(type))
            {
               if(type == this.soapConstants.soapBase64QName)
               {
                  type = datatypes.base64BinaryQName;
               }
               else
               {
                  localName = type.localName;
                  if(localName != "Array" && localName != "arrayType")
                  {
                     type = this.schemaConstants.getQName(localName);
                  }
               }
            }
         }
         var customType:ICustomSOAPType = SOAPConstants.getCustomSOAPType(type);
         if(customType != null)
         {
            customType.encode(this,parent,name,value,restriction);
         }
         else
         {
            super.encodeType(type,parent,name,value,restriction);
         }
         if(xsiType != null)
         {
            xsiTypeAttr = parent[this.schemaConstants.getXSIToken(this.schemaConstants.typeAttrQName)];
            if(xsiTypeAttr == null || xsiTypeAttr == "")
            {
               super.setXSIType(parent,xsiType);
            }
         }
      }
      
      override public function encodeComplexRestriction(restriction:XML, parent:XML, name:QName, value:*) : void
      {
         var customType:ICustomSOAPType = null;
         var schemaConstants:SchemaConstants = schemaManager.schemaConstants;
         var baseName:String = restriction.@base;
         var baseQName:QName = schemaManager.getQNameForPrefixedName(baseName,restriction);
         if(baseQName == this.soapConstants.soapencArrayQName)
         {
            customType = SOAPConstants.getCustomSOAPType(baseQName);
            if(customType != null)
            {
               customType.encode(this,parent,name,value,restriction);
               return;
            }
         }
         super.encodeComplexRestriction(restriction,parent,name,value);
      }
      
      override protected function deriveXSIType(parent:XML, type:QName, value:*) : void
      {
         var datatypes:SchemaDatatypes = null;
         var soapType:QName = null;
         var localName:String = null;
         if(this.isSOAPEncoding)
         {
            datatypes = schemaManager.schemaDatatypes;
            if(type == datatypes.anyTypeQName || type == datatypes.anySimpleTypeQName)
            {
               if(isSimpleValue(value) || type == datatypes.anySimpleTypeQName)
               {
                  localName = SchemaMarshaller.guessSimpleType(value);
                  soapType = new QName(this.schemaConstants.xsdURI,localName);
               }
            }
            else
            {
               soapType = type;
            }
            if(soapType != null)
            {
               parent[this.schemaConstants.getXSIToken(this.schemaConstants.typeAttrQName)] = this.schemaConstants.getXSDToken(soapType);
            }
         }
      }
   }
}

