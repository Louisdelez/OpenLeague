package mx.rpc.wsdl
{
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import mx.rpc.Fault;
   import mx.rpc.soap.SOAPConstants;
   import mx.rpc.xml.QualifiedResourceManager;
   import mx.rpc.xml.Schema;
   import mx.rpc.xml.SchemaConstants;
   import mx.rpc.xml.SchemaManager;
   
   [ExcludeClass]
   [ResourceBundle("rpc")]
   public class WSDL
   {
      
      private var resourceManager:IResourceManager = ResourceManager.getInstance();
      
      private var _schemaManager:SchemaManager;
      
      private var _wsdlConstants:WSDLConstants;
      
      private var _log:ILogger;
      
      private var importsManager:QualifiedResourceManager;
      
      private var _targetNamespace:Namespace;
      
      private var _schemaConstants:SchemaConstants;
      
      private var _soapConstants:SOAPConstants;
      
      private var serviceMap:Object;
      
      private var namespaces:Object;
      
      private var _xml:XML;
      
      public function WSDL(xml:XML, topLevelManager:SchemaManager = null)
      {
         super();
         if(topLevelManager != null)
         {
            _schemaManager = topLevelManager;
         }
         _xml = xml;
         _log = Log.getLogger("mx.rpc.wsdl.WSDL");
         processNamespaces();
         processSchemas();
      }
      
      private function parseService(serviceName:String = null, portName:String = null) : WSDLService
      {
         var service:WSDLService = null;
         var serviceXML:XML = null;
         var x:XML = null;
         var port:WSDLPort = null;
         var imports:Array = null;
         var childWSDL:WSDL = null;
         var serviceXMLList:XMLList = xml.elements(wsdlConstants.serviceQName);
         for each(x in serviceXMLList)
         {
            if(serviceName == null)
            {
               serviceXML = x;
               serviceName = x.@name.toString();
               break;
            }
            if(x.@name == serviceName)
            {
               serviceXML = x;
               break;
            }
         }
         if(serviceXML != null)
         {
            service = new WSDLService(serviceName);
            port = parsePort(service,serviceXML,portName);
            if(port != null)
            {
               service.addPort(port);
            }
         }
         else if(importsManager != null)
         {
            imports = importsManager.getResources();
            for each(childWSDL in imports)
            {
               service = childWSDL.parseService(serviceName,portName);
               if(service != null)
               {
                  break;
               }
            }
         }
         return service;
      }
      
      public function getTypes(targetNamespace:Namespace) : XML
      {
         var types:XML = null;
         var imports:Array = null;
         var childWSDL:WSDL = null;
         var typesXMLList:XMLList = xml.elements(wsdlConstants.typesQName);
         if(typesXMLList.length() > 0)
         {
            types = typesXMLList[0];
         }
         else if(importsManager != null)
         {
            imports = importsManager.getResourcesForNamespace(targetNamespace);
            for each(childWSDL in imports)
            {
               types = childWSDL.getTypes(targetNamespace);
               if(types != null)
               {
                  break;
               }
            }
         }
         return types;
      }
      
      public function get soapConstants() : SOAPConstants
      {
         if(_soapConstants == null)
         {
            _soapConstants = SOAPConstants.getConstants(xml);
         }
         return _soapConstants;
      }
      
      private function processNamespaces() : void
      {
         var tns:String = null;
         var nsArray:Array = null;
         var ns:Namespace = null;
         if(_xml != null)
         {
            tns = _xml.@targetNamespace.toString();
            _targetNamespace = new Namespace(tns);
            namespaces = {};
            nsArray = _xml.namespaceDeclarations();
            for each(ns in nsArray)
            {
               namespaces[ns.prefix] = ns;
            }
            _wsdlConstants = WSDLConstants.getConstants(_xml);
            _schemaConstants = SchemaConstants.getConstants(_xml);
            schemaManager.addNamespaces(namespaces);
         }
      }
      
      public function get targetNamespace() : Namespace
      {
         return _targetNamespace;
      }
      
      public function get wsdlConstants() : WSDLConstants
      {
         if(_wsdlConstants == null)
         {
            _wsdlConstants = WSDLConstants.getConstants(xml);
         }
         return _wsdlConstants;
      }
      
      public function get schemaManager() : SchemaManager
      {
         if(_schemaManager == null)
         {
            _schemaManager = new SchemaManager();
            _schemaManager.schemaConstants = schemaConstants;
         }
         return _schemaManager;
      }
      
      private function parseBinding(bindingQName:QName) : WSDLBinding
      {
         var binding:WSDLBinding = null;
         var bindingXML:XML = null;
         var x:XML = null;
         var soapBindingXMLList:XMLList = null;
         var prefixedTypeName:String = null;
         var portTypeQName:QName = null;
         var portType:WSDLPortType = null;
         var operationXMLList:XMLList = null;
         var operationXML:XML = null;
         var style:String = null;
         var transport:String = null;
         var operationName:String = null;
         var operation:WSDLOperation = null;
         var soapOperationXMLList:XMLList = null;
         var operationExtensionXMLList:XMLList = null;
         var operationExtensionXML:XML = null;
         var encoding:WSDLEncoding = null;
         var extensionXMLList:XMLList = null;
         var extensionXML:XML = null;
         var extensionName:String = null;
         var extensionMessage:WSDLMessage = null;
         var soapAction:String = null;
         var opStyle:String = null;
         var faultName:String = null;
         var imports:Array = null;
         var childWSDL:WSDL = null;
         var bindingXMLList:XMLList = xml.elements(wsdlConstants.bindingQName);
         for each(x in bindingXMLList)
         {
            if(x.@name == bindingQName.localName)
            {
               bindingXML = x;
               break;
            }
         }
         if(bindingXML != null)
         {
            binding = new WSDLBinding(bindingQName.localName);
            soapBindingXMLList = bindingXML.elements(wsdlConstants.soapBindingQName);
            if(soapBindingXMLList.length() > 0)
            {
               style = soapBindingXMLList[0].@style.toString();
               binding.style = style;
               transport = soapBindingXMLList[0].@transport.toString();
               binding.transport = transport;
            }
            prefixedTypeName = bindingXML.@type.toString();
            portTypeQName = schemaManager.getQNameForPrefixedName(prefixedTypeName,bindingXML);
            portType = new WSDLPortType(portTypeQName.localName);
            binding.portType = portType;
            operationXMLList = bindingXML.elements(wsdlConstants.operationQName);
            for each(operationXML in operationXMLList)
            {
               operationName = operationXML.@name.toString();
               operation = new WSDLOperation(operationName);
               operation.schemaManager = schemaManager;
               operation.namespaces = namespaces;
               operation.wsdlConstants = wsdlConstants;
               soapOperationXMLList = operationXML.elements(wsdlConstants.soapOperationQName);
               if(soapOperationXMLList.length() > 0)
               {
                  soapAction = soapOperationXMLList[0].@soapAction.toString();
                  operation.soapAction = soapAction;
                  opStyle = soapOperationXMLList[0].@style.toString();
                  if(opStyle == "")
                  {
                     operation.style = binding.style;
                  }
                  else
                  {
                     operation.style = opStyle;
                  }
               }
               operationExtensionXMLList = operationXML.elements(wsdlConstants.inputQName);
               if(operationExtensionXMLList.length() > 0)
               {
                  operationExtensionXML = operationExtensionXMLList[0];
                  operation.inputMessage = new WSDLMessage();
                  extensionXMLList = operationExtensionXML.elements(wsdlConstants.soapBodyQName);
                  if(extensionXMLList.length() > 0)
                  {
                     extensionXML = extensionXMLList[0];
                     encoding = parseEncodingExtension(extensionXML);
                     operation.inputMessage.encoding = encoding;
                  }
                  extensionXMLList = operationExtensionXML.elements(wsdlConstants.soapHeaderQName);
                  for each(extensionXML in extensionXMLList)
                  {
                     extensionMessage = parseHeader(operationName,extensionXML);
                     operation.inputMessage.addHeader(extensionMessage);
                  }
                  extensionXMLList = operationExtensionXML.elements(wsdlConstants.soapHeaderFaultQName);
                  for each(extensionXML in extensionXMLList)
                  {
                     extensionMessage = parseHeader(operationName,extensionXML);
                     operation.inputMessage.addHeaderFault(extensionMessage);
                  }
               }
               operationExtensionXMLList = operationXML.elements(wsdlConstants.outputQName);
               if(operationExtensionXMLList.length() > 0)
               {
                  operationExtensionXML = operationExtensionXMLList[0];
                  operation.outputMessage = new WSDLMessage();
                  extensionXMLList = operationExtensionXML.elements(wsdlConstants.soapBodyQName);
                  if(extensionXMLList.length() > 0)
                  {
                     extensionXML = extensionXMLList[0];
                     encoding = parseEncodingExtension(extensionXML);
                     operation.outputMessage.encoding = encoding;
                  }
                  extensionXMLList = operationExtensionXML.elements(wsdlConstants.soapHeaderQName);
                  for each(extensionXML in extensionXMLList)
                  {
                     extensionMessage = parseHeader(operationName,extensionXML);
                     operation.outputMessage.addHeader(extensionMessage);
                  }
                  extensionXMLList = operationExtensionXML.elements(wsdlConstants.soapHeaderFaultQName);
                  for each(extensionXML in extensionXMLList)
                  {
                     extensionMessage = parseHeader(operationName,extensionXML);
                     operation.outputMessage.addHeaderFault(extensionMessage);
                  }
               }
               operationExtensionXMLList = operationXML.elements(wsdlConstants.faultQName);
               for each(operationExtensionXML in operationExtensionXMLList)
               {
                  extensionXMLList = operationExtensionXML.elements(wsdlConstants.soapFaultQName);
                  if(extensionXMLList.length() > 0)
                  {
                     extensionXML = extensionXMLList[0];
                     faultName = extensionXML["name"].toString();
                     extensionMessage = new WSDLMessage(faultName);
                     encoding = parseEncodingExtension(extensionXML,false,true);
                     extensionMessage.encoding = encoding;
                     operation.addFault(extensionMessage);
                  }
               }
               portType.addOperation(operation);
            }
            parsePortType(portTypeQName,portType);
         }
         else if(importsManager != null)
         {
            imports = importsManager.getResources();
            for each(childWSDL in imports)
            {
               binding = childWSDL.parseBinding(bindingQName);
               if(binding != null)
               {
                  break;
               }
            }
         }
         return binding;
      }
      
      private function parsePort(service:WSDLService, serviceXML:XML, portName:String = null) : WSDLPort
      {
         var port:WSDLPort = null;
         var portXML:XML = null;
         var x:XML = null;
         var soapAddressXMLList:XMLList = null;
         var prefixedBindingName:String = null;
         var bindingQName:QName = null;
         var binding:WSDLBinding = null;
         var message:String = null;
         var portXMLList:XMLList = serviceXML.elements(wsdlConstants.portQName);
         for each(x in portXMLList)
         {
            if(portName == null)
            {
               portXML = x;
               portName = x.@name.toString();
               break;
            }
            if(x.@name == portName)
            {
               portXML = x;
               break;
            }
         }
         if(portXML != null)
         {
            port = new WSDLPort(portName,service);
            soapAddressXMLList = portXML.elements(wsdlConstants.soapAddressQName);
            if(soapAddressXMLList.length() > 0)
            {
               port.endpointURI = soapAddressXMLList[0].@location.toString();
            }
            prefixedBindingName = portXML.@binding.toString();
            bindingQName = schemaManager.getQNameForPrefixedName(prefixedBindingName,portXML);
            binding = parseBinding(bindingQName);
            if(binding == null)
            {
               message = resourceManager.getString("rpc","unrecognizedBindingName",[bindingQName.localName,bindingQName.uri]);
               throw new Fault("WSDL.UnrecognizedBindingName",message);
            }
            port.binding = binding;
         }
         return port;
      }
      
      public function get xml() : XML
      {
         return _xml;
      }
      
      private function parseDocumentOperation(operation:WSDLOperation) : void
      {
         var part:WSDLMessagePart = null;
         var element:XML = null;
         var elementTypeString:String = null;
         var elementType:QName = null;
         var complexTypes:XMLList = null;
         var complexType:XML = null;
         var attributes:XMLList = null;
         var sequences:XMLList = null;
         var sequence:XML = null;
         var input:WSDLMessage = null;
         var requestElements:XMLList = null;
         var requestElement:XML = null;
         var output:WSDLMessage = null;
         var resultElements:XMLList = null;
         var resultElement:XML = null;
         if(operation.inputMessage != null && operation.inputMessage.encoding != null && operation.inputMessage.encoding.useStyle == SOAPConstants.USE_LITERAL)
         {
            input = operation.inputMessage;
            if(input.parts != null && input.parts.length == 1)
            {
               schemaManager.reset();
               part = input.parts[0];
               if(part.element != null)
               {
                  element = schemaManager.getNamedDefinition(part.element,schemaConstants.elementTypeQName);
                  if(element != null && element["name"] == operation.name)
                  {
                     elementTypeString = element["type"];
                     if(elementTypeString != null && elementTypeString != "")
                     {
                        elementType = schemaManager.getQNameForPrefixedName(elementTypeString,element);
                        complexType = schemaManager.getNamedDefinition(elementType,schemaConstants.complexTypeQName);
                     }
                     else
                     {
                        complexTypes = element.elements(schemaConstants.complexTypeQName);
                        if(complexTypes.length() == 1)
                        {
                           complexType = complexTypes[0];
                        }
                     }
                     if(complexType != null)
                     {
                        attributes = complexType.elements(schemaConstants.attributeQName);
                        if(attributes.length() == 0)
                        {
                           sequences = complexType.elements(schemaConstants.sequenceQName);
                           if(complexType.elements().length() == 0 || sequences.length() == 1)
                           {
                              input.isWrapped = true;
                              input.wrappedQName = part.element;
                              input.parts = [];
                              if(sequences.length() == 1)
                              {
                                 sequence = sequences[0];
                                 requestElements = sequence.elements(schemaConstants.elementTypeQName);
                                 for each(requestElement in requestElements)
                                 {
                                    part = parseWrappedMessagePart(requestElement);
                                    input.addPart(part);
                                 }
                              }
                           }
                        }
                     }
                  }
               }
            }
         }
         complexType = null;
         elementTypeString = null;
         if(operation.outputMessage != null && operation.outputMessage.encoding != null && operation.outputMessage.encoding.useStyle == SOAPConstants.USE_LITERAL)
         {
            output = operation.outputMessage;
            if(output.parts != null && output.parts.length == 1)
            {
               part = output.parts[0];
               if(part.element != null)
               {
                  schemaManager.reset();
                  element = schemaManager.getNamedDefinition(part.element,schemaConstants.elementTypeQName);
                  if(element != null)
                  {
                     elementTypeString = element["type"];
                     if(elementTypeString != null && elementTypeString != "")
                     {
                        elementType = schemaManager.getQNameForPrefixedName(elementTypeString,element);
                        complexType = schemaManager.getNamedDefinition(elementType,schemaConstants.complexTypeQName);
                     }
                     else
                     {
                        complexTypes = element.elements(schemaConstants.complexTypeQName);
                        if(complexTypes.length() == 1)
                        {
                           complexType = complexTypes[0];
                        }
                     }
                     if(complexType != null)
                     {
                        attributes = complexType.elements(schemaConstants.attributeQName);
                        if(attributes.length() == 0)
                        {
                           sequences = complexType.elements(schemaConstants.sequenceQName);
                           if(complexType.elements().length() == 0 || sequences.length() == 1)
                           {
                              output.isWrapped = true;
                              output.wrappedQName = part.element;
                              output.parts = [];
                              if(sequences.length() == 1)
                              {
                                 sequence = sequences[0];
                                 resultElements = sequence.elements(schemaConstants.elementTypeQName);
                                 for each(resultElement in resultElements)
                                 {
                                    part = parseWrappedMessagePart(resultElement);
                                    output.addPart(part);
                                 }
                              }
                           }
                        }
                     }
                  }
               }
            }
         }
      }
      
      private function parseMessage(message:WSDLMessage, messageQName:QName, operationName:String, mode:int) : Boolean
      {
         var messageXML:XML = null;
         var foundMatchingMessage:Boolean = false;
         var x:XML = null;
         var partXMLList:XMLList = null;
         var partXML:XML = null;
         var partName:String = null;
         var part:WSDLMessagePart = null;
         var imports:Array = null;
         var childWSDL:WSDL = null;
         var encoding:WSDLEncoding = message.encoding;
         var messageXMLList:XMLList = xml.elements(wsdlConstants.messageQName);
         for each(x in messageXMLList)
         {
            if(x.@name == messageQName.localName)
            {
               messageXML = x;
               break;
            }
         }
         if(messageXML != null)
         {
            foundMatchingMessage = true;
            if(message.name == null || message.name == "")
            {
               if(mode == WSDLConstants.MODE_IN)
               {
                  message.name = operationName + "Request";
               }
               else if(mode == WSDLConstants.MODE_OUT)
               {
                  message.name = operationName + "Response";
               }
            }
            partXMLList = messageXML.elements(wsdlConstants.partQName);
            for each(partXML in partXMLList)
            {
               partName = partXML.@name;
               if(!(encoding != null && !encoding.hasPart(partName)))
               {
                  part = parseMessagePart(partXML);
                  message.addPart(part);
               }
            }
         }
         else if(importsManager != null)
         {
            imports = importsManager.getResources();
            for each(childWSDL in imports)
            {
               foundMatchingMessage = childWSDL.parseMessage(message,messageQName,operationName,mode);
               if(foundMatchingMessage)
               {
                  break;
               }
            }
         }
         return foundMatchingMessage;
      }
      
      private function parseHeader(operationName:String, headerXML:XML) : WSDLMessage
      {
         var headerName:String = headerXML["part"].toString();
         var headerMessage:WSDLMessage = new WSDLMessage(headerName);
         var encoding:WSDLEncoding = parseEncodingExtension(headerXML,true);
         headerMessage.encoding = encoding;
         parseMessage(headerMessage,encoding.message,operationName,WSDLConstants.MODE_HEADER);
         return headerMessage;
      }
      
      public function addSchema(schema:Schema) : void
      {
         schemaManager.addSchema(schema);
      }
      
      private function processSchemas() : void
      {
         var schemas:XMLList = null;
         var schemaXML:XML = null;
         var schema:Schema = null;
         var types:XML = getTypes(targetNamespace);
         if(types != null)
         {
            schemas = types.elements(schemaConstants.schemaQName);
            for each(schemaXML in schemas)
            {
               schema = new Schema(schemaXML);
               addSchema(schema);
            }
         }
      }
      
      public function addImport(targetNamespace:Namespace, wsdl:WSDL) : void
      {
         if(importsManager == null)
         {
            importsManager = new QualifiedResourceManager();
         }
         importsManager.addResource(targetNamespace,wsdl);
      }
      
      private function parseMessagePart(partXML:XML) : WSDLMessagePart
      {
         var elementName:String = null;
         var elementQName:QName = null;
         var typeName:String = null;
         var typeQName:QName = null;
         var partName:String = partXML.@name;
         var partQName:QName = new QName("",partName);
         var part:WSDLMessagePart = new WSDLMessagePart(partQName);
         var partXMLElement:String = partXML.@element;
         var partXMLType:String = partXML.@type;
         if(partXMLElement != "")
         {
            elementName = partXML.@element;
            elementQName = schemaManager.getQNameForPrefixedName(elementName,partXML);
            part.element = elementQName;
         }
         else if(partXMLType != "")
         {
            typeName = partXML.@type;
            typeQName = schemaManager.getQNameForPrefixedName(typeName,partXML);
            part.type = typeQName;
         }
         return part;
      }
      
      private function parseWrappedMessagePart(elementXML:XML) : WSDLMessagePart
      {
         var ref:QName = null;
         var partType:String = null;
         if(elementXML.attribute("ref").length() == 1)
         {
            ref = schemaManager.getQNameForPrefixedName(elementXML.@ref,elementXML,true);
            elementXML = schemaManager.getNamedDefinition(ref,schemaConstants.elementTypeQName);
            if(elementXML == null)
            {
               throw new Error("Cannot resolve element definition for ref \'" + ref + "\'");
            }
         }
         var partName:String = elementXML.@name;
         var partQName:QName = schemaManager.getQNameForElement(partName,elementXML.@form);
         var part:WSDLMessagePart = new WSDLMessagePart(partQName);
         var minOccurs:String = elementXML.@minOccurs;
         var maxOccurs:String = elementXML.@maxOccurs;
         if(minOccurs != "" && parseInt(minOccurs) == 0)
         {
            part.optional = true;
         }
         if(ref != null)
         {
            part.element = ref;
         }
         else
         {
            partType = elementXML.@type;
            if(partType != "" || !elementXML.hasComplexContent())
            {
               if(partType == null || partType == "")
               {
                  part.type = schemaConstants.anyTypeQName;
               }
               else
               {
                  part.type = schemaManager.getQNameForPrefixedName(partType,elementXML);
               }
               if(minOccurs != "" || maxOccurs != "")
               {
                  part.definition = elementXML;
               }
            }
            else if(elementXML.hasComplexContent())
            {
               part.definition = elementXML;
            }
         }
         if(ref != null)
         {
            schemaManager.releaseScope();
         }
         return part;
      }
      
      public function get schemaConstants() : SchemaConstants
      {
         if(_schemaConstants == null)
         {
            _schemaConstants = SchemaConstants.getConstants(xml);
         }
         return _schemaConstants;
      }
      
      public function getOperation(operationName:String, serviceName:String = null, portName:String = null) : WSDLOperation
      {
         var port:WSDLPort = getPort(serviceName,portName);
         var binding:WSDLBinding = port.binding;
         var portType:WSDLPortType = binding.portType;
         return portType.getOperation(operationName);
      }
      
      private function parsePortType(portTypeQName:QName, portType:WSDLPortType) : Boolean
      {
         var portTypeXML:XML = null;
         var foundMatchingPortType:Boolean = false;
         var x:XML = null;
         var operationsXMLList:XMLList = null;
         var operationXML:XML = null;
         var operationName:String = null;
         var operation:WSDLOperation = null;
         var messageName:String = null;
         var messageQName:QName = null;
         var message:WSDLMessage = null;
         var inputXMLList:XMLList = null;
         var outputXMLList:XMLList = null;
         var faultsXMLList:XMLList = null;
         var faultXML:XML = null;
         var faultName:String = null;
         var imports:Array = null;
         var childWSDL:WSDL = null;
         var portTypeXMLList:XMLList = xml.elements(wsdlConstants.portTypeQName);
         for each(x in portTypeXMLList)
         {
            if(x.@name == portTypeQName.localName)
            {
               portTypeXML = x;
               break;
            }
         }
         if(portTypeXML != null)
         {
            foundMatchingPortType = true;
            operationsXMLList = portTypeXML.elements(wsdlConstants.operationQName);
            for each(operationXML in operationsXMLList)
            {
               operationName = operationXML.@name.toString();
               operation = portType.getOperation(operationName);
               if(operation == null)
               {
                  _log.warn("An operation \'{0}\' was found in the port type but is missing binding information.",operationName);
               }
               else
               {
                  inputXMLList = operationXML.elements(wsdlConstants.inputQName);
                  if(inputXMLList.length() > 0)
                  {
                     schemaManager.reset();
                     messageName = inputXMLList[0].@message.toString();
                     messageQName = schemaManager.getQNameForPrefixedName(messageName,inputXMLList[0]);
                     message = operation.inputMessage;
                     message.name = messageQName.localName;
                     parseMessage(message,messageQName,operationName,WSDLConstants.MODE_IN);
                  }
                  outputXMLList = operationXML.elements(wsdlConstants.outputQName);
                  if(outputXMLList.length() > 0)
                  {
                     schemaManager.reset();
                     messageName = outputXMLList[0].@message.toString();
                     messageQName = schemaManager.getQNameForPrefixedName(messageName,outputXMLList[0]);
                     message = operation.outputMessage;
                     message.name = messageQName.localName;
                     parseMessage(message,messageQName,operationName,WSDLConstants.MODE_OUT);
                  }
                  faultsXMLList = operationXML.elements(wsdlConstants.faultQName);
                  for each(faultXML in faultsXMLList)
                  {
                     schemaManager.reset();
                     faultName = faultXML.@name.toString();
                     message = operation.getFault(faultName);
                     if(message != null)
                     {
                        messageName = faultXML.@message.toString();
                        messageQName = schemaManager.getQNameForPrefixedName(messageName,faultXML);
                        parseMessage(message,messageQName,operationName,WSDLConstants.MODE_FAULT);
                     }
                  }
                  if(operation.style == SOAPConstants.DOC_STYLE)
                  {
                     parseDocumentOperation(operation);
                  }
               }
            }
         }
         else if(importsManager != null)
         {
            imports = importsManager.getResources();
            for each(childWSDL in imports)
            {
               foundMatchingPortType = childWSDL.parsePortType(portTypeQName,portType);
               if(foundMatchingPortType)
               {
                  break;
               }
            }
         }
         return foundMatchingPortType;
      }
      
      public function getPort(serviceName:String = null, portName:String = null) : WSDLPort
      {
         var port:WSDLPort = null;
         var message:String = null;
         var service:WSDLService = getService(serviceName,portName);
         if(service != null)
         {
            if(portName == null)
            {
               port = service.defaultPort;
            }
            else
            {
               port = service.getPort(portName);
            }
         }
         if(port == null)
         {
            message = resourceManager.getString("rpc","noServiceAndPort",[serviceName,portName]);
            throw new Fault("Client.NoSuchPort",message);
         }
         return port;
      }
      
      private function parseEncodingExtension(extensionXML:XML, isHeader:Boolean = false, isFault:Boolean = false) : WSDLEncoding
      {
         var messageName:String = null;
         var encoding:WSDLEncoding = new WSDLEncoding();
         encoding.useStyle = extensionXML["use"].toString();
         encoding.namespaceURI = extensionXML["namespace"].toString();
         encoding.encodingStyle = extensionXML["encodingStyle"].toString();
         if(isHeader)
         {
            messageName = extensionXML["message"].toString();
            encoding.message = schemaManager.getQNameForPrefixedName(messageName,extensionXML);
            encoding.setParts(extensionXML["part"].toString());
         }
         else if(!isFault)
         {
            encoding.setParts(extensionXML["parts"].toString());
         }
         return encoding;
      }
      
      public function getService(serviceName:String = null, portName:String = null) : WSDLService
      {
         var service:WSDLService = null;
         var port:WSDLPort = null;
         var tempService:WSDLService = null;
         var p:WSDLPort = null;
         var message:String = null;
         var detail:String = null;
         if(serviceMap != null && serviceName != null)
         {
            service = serviceMap[serviceName];
            if(service != null)
            {
               if(portName != null)
               {
                  port = service.getPort(portName);
               }
               if(port == null)
               {
                  tempService = parseService(serviceName,portName);
                  for each(p in tempService.ports)
                  {
                     service.addPort(p);
                  }
               }
            }
         }
         if(service == null)
         {
            service = parseService(serviceName,portName);
            if(service == null)
            {
               if(serviceName != null)
               {
                  message = resourceManager.getString("rpc","noSuchServiceInWSDL",[serviceName]);
                  throw new Fault("Client.NoSuchService",message);
               }
               message = resourceManager.getString("rpc","noServiceElement");
               detail = resourceManager.getString("rpc","noServiceElement.details",[""]);
               throw new Fault("Server.NoServicesInWSDL",message,detail);
            }
            if(serviceMap == null)
            {
               serviceMap = {};
            }
            serviceMap[service.name] = service;
         }
         return service;
      }
   }
}

