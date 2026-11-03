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
      
      private var importsManager:QualifiedResourceManager;
      
      private var _log:ILogger;
      
      private var namespaces:Object;
      
      private var _schemaConstants:SchemaConstants;
      
      private var _schemaManager:SchemaManager;
      
      private var serviceMap:Object;
      
      private var _soapConstants:SOAPConstants;
      
      private var _targetNamespace:Namespace;
      
      private var _wsdlConstants:WSDLConstants;
      
      private var _xml:XML;
      
      public function WSDL(xml:XML, topLevelManager:SchemaManager = null)
      {
         super();
         if(topLevelManager != null)
         {
            this._schemaManager = topLevelManager;
         }
         this._xml = xml;
         this._log = Log.getLogger("mx.rpc.wsdl.WSDL");
         this.processNamespaces();
         this.processSchemas();
      }
      
      public function get schemaManager() : SchemaManager
      {
         if(this._schemaManager == null)
         {
            this._schemaManager = new SchemaManager();
            this._schemaManager.schemaConstants = this.schemaConstants;
         }
         return this._schemaManager;
      }
      
      public function get schemaConstants() : SchemaConstants
      {
         if(this._schemaConstants == null)
         {
            this._schemaConstants = SchemaConstants.getConstants(this.xml);
         }
         return this._schemaConstants;
      }
      
      public function get soapConstants() : SOAPConstants
      {
         if(this._soapConstants == null)
         {
            this._soapConstants = SOAPConstants.getConstants(this.xml);
         }
         return this._soapConstants;
      }
      
      public function get targetNamespace() : Namespace
      {
         return this._targetNamespace;
      }
      
      public function get wsdlConstants() : WSDLConstants
      {
         if(this._wsdlConstants == null)
         {
            this._wsdlConstants = WSDLConstants.getConstants(this.xml);
         }
         return this._wsdlConstants;
      }
      
      public function get xml() : XML
      {
         return this._xml;
      }
      
      public function addImport(targetNamespace:Namespace, wsdl:WSDL) : void
      {
         if(this.importsManager == null)
         {
            this.importsManager = new QualifiedResourceManager();
         }
         this.importsManager.addResource(targetNamespace,wsdl);
      }
      
      public function addSchema(schema:Schema) : void
      {
         this.schemaManager.addSchema(schema);
      }
      
      public function getOperation(operationName:String, serviceName:String = null, portName:String = null) : WSDLOperation
      {
         var port:WSDLPort = this.getPort(serviceName,portName);
         var binding:WSDLBinding = port.binding;
         var portType:WSDLPortType = binding.portType;
         return portType.getOperation(operationName);
      }
      
      public function getPort(serviceName:String = null, portName:String = null) : WSDLPort
      {
         var port:WSDLPort = null;
         var message:String = null;
         var service:WSDLService = this.getService(serviceName,portName);
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
            message = this.resourceManager.getString("rpc","noServiceAndPort",[serviceName,portName]);
            throw new Fault("Client.NoSuchPort",message);
         }
         return port;
      }
      
      public function getService(serviceName:String = null, portName:String = null) : WSDLService
      {
         var service:WSDLService = null;
         var port:WSDLPort = null;
         var tempService:WSDLService = null;
         var p:WSDLPort = null;
         var message:String = null;
         var detail:String = null;
         if(this.serviceMap != null && serviceName != null)
         {
            service = this.serviceMap[serviceName];
            if(service != null)
            {
               if(portName != null)
               {
                  port = service.getPort(portName);
               }
               if(port == null)
               {
                  tempService = this.parseService(serviceName,portName);
                  for each(p in tempService.ports)
                  {
                     service.addPort(p);
                  }
               }
            }
         }
         if(service == null)
         {
            service = this.parseService(serviceName,portName);
            if(service == null)
            {
               if(serviceName != null)
               {
                  message = this.resourceManager.getString("rpc","noSuchServiceInWSDL",[serviceName]);
                  throw new Fault("Client.NoSuchService",message);
               }
               message = this.resourceManager.getString("rpc","noServiceElement");
               detail = this.resourceManager.getString("rpc","noServiceElement.details",[""]);
               throw new Fault("Server.NoServicesInWSDL",message,detail);
            }
            if(this.serviceMap == null)
            {
               this.serviceMap = {};
            }
            this.serviceMap[service.name] = service;
         }
         return service;
      }
      
      public function getTypes(targetNamespace:Namespace) : XML
      {
         var types:XML = null;
         var imports:Array = null;
         var childWSDL:WSDL = null;
         var typesXMLList:XMLList = this.xml.elements(this.wsdlConstants.typesQName);
         if(typesXMLList.length() > 0)
         {
            types = typesXMLList[0];
         }
         else if(this.importsManager != null)
         {
            imports = this.importsManager.getResourcesForNamespace(targetNamespace);
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
      
      private function parseService(serviceName:String = null, portName:String = null) : WSDLService
      {
         var service:WSDLService = null;
         var serviceXML:XML = null;
         var x:XML = null;
         var port:WSDLPort = null;
         var imports:Array = null;
         var childWSDL:WSDL = null;
         var serviceXMLList:XMLList = this.xml.elements(this.wsdlConstants.serviceQName);
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
            port = this.parsePort(service,serviceXML,portName);
            if(port != null)
            {
               service.addPort(port);
            }
         }
         else if(this.importsManager != null)
         {
            imports = this.importsManager.getResources();
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
         var portXMLList:XMLList = serviceXML.elements(this.wsdlConstants.portQName);
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
            soapAddressXMLList = portXML.elements(this.wsdlConstants.soapAddressQName);
            if(soapAddressXMLList.length() > 0)
            {
               port.endpointURI = soapAddressXMLList[0].@location.toString();
            }
            prefixedBindingName = portXML.@binding.toString();
            bindingQName = this.schemaManager.getQNameForPrefixedName(prefixedBindingName,portXML);
            binding = this.parseBinding(bindingQName);
            if(binding == null)
            {
               message = this.resourceManager.getString("rpc","unrecognizedBindingName",[bindingQName.localName,bindingQName.uri]);
               throw new Fault("WSDL.UnrecognizedBindingName",message);
            }
            port.binding = binding;
         }
         return port;
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
         var bindingXMLList:XMLList = this.xml.elements(this.wsdlConstants.bindingQName);
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
            soapBindingXMLList = bindingXML.elements(this.wsdlConstants.soapBindingQName);
            if(soapBindingXMLList.length() > 0)
            {
               style = soapBindingXMLList[0].@style.toString();
               binding.style = style;
               transport = soapBindingXMLList[0].@transport.toString();
               binding.transport = transport;
            }
            prefixedTypeName = bindingXML.@type.toString();
            portTypeQName = this.schemaManager.getQNameForPrefixedName(prefixedTypeName,bindingXML);
            portType = new WSDLPortType(portTypeQName.localName);
            binding.portType = portType;
            operationXMLList = bindingXML.elements(this.wsdlConstants.operationQName);
            for each(operationXML in operationXMLList)
            {
               operationName = operationXML.@name.toString();
               operation = new WSDLOperation(operationName);
               operation.schemaManager = this.schemaManager;
               operation.namespaces = this.namespaces;
               operation.wsdlConstants = this.wsdlConstants;
               soapOperationXMLList = operationXML.elements(this.wsdlConstants.soapOperationQName);
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
               operationExtensionXMLList = operationXML.elements(this.wsdlConstants.inputQName);
               if(operationExtensionXMLList.length() > 0)
               {
                  operationExtensionXML = operationExtensionXMLList[0];
                  operation.inputMessage = new WSDLMessage();
                  extensionXMLList = operationExtensionXML.elements(this.wsdlConstants.soapBodyQName);
                  if(extensionXMLList.length() > 0)
                  {
                     extensionXML = extensionXMLList[0];
                     encoding = this.parseEncodingExtension(extensionXML);
                     operation.inputMessage.encoding = encoding;
                  }
                  extensionXMLList = operationExtensionXML.elements(this.wsdlConstants.soapHeaderQName);
                  for each(extensionXML in extensionXMLList)
                  {
                     extensionMessage = this.parseHeader(operationName,extensionXML);
                     operation.inputMessage.addHeader(extensionMessage);
                  }
                  extensionXMLList = operationExtensionXML.elements(this.wsdlConstants.soapHeaderFaultQName);
                  for each(extensionXML in extensionXMLList)
                  {
                     extensionMessage = this.parseHeader(operationName,extensionXML);
                     operation.inputMessage.addHeaderFault(extensionMessage);
                  }
               }
               operationExtensionXMLList = operationXML.elements(this.wsdlConstants.outputQName);
               if(operationExtensionXMLList.length() > 0)
               {
                  operationExtensionXML = operationExtensionXMLList[0];
                  operation.outputMessage = new WSDLMessage();
                  extensionXMLList = operationExtensionXML.elements(this.wsdlConstants.soapBodyQName);
                  if(extensionXMLList.length() > 0)
                  {
                     extensionXML = extensionXMLList[0];
                     encoding = this.parseEncodingExtension(extensionXML);
                     operation.outputMessage.encoding = encoding;
                  }
                  extensionXMLList = operationExtensionXML.elements(this.wsdlConstants.soapHeaderQName);
                  for each(extensionXML in extensionXMLList)
                  {
                     extensionMessage = this.parseHeader(operationName,extensionXML);
                     operation.outputMessage.addHeader(extensionMessage);
                  }
                  extensionXMLList = operationExtensionXML.elements(this.wsdlConstants.soapHeaderFaultQName);
                  for each(extensionXML in extensionXMLList)
                  {
                     extensionMessage = this.parseHeader(operationName,extensionXML);
                     operation.outputMessage.addHeaderFault(extensionMessage);
                  }
               }
               operationExtensionXMLList = operationXML.elements(this.wsdlConstants.faultQName);
               for each(operationExtensionXML in operationExtensionXMLList)
               {
                  extensionXMLList = operationExtensionXML.elements(this.wsdlConstants.soapFaultQName);
                  if(extensionXMLList.length() > 0)
                  {
                     extensionXML = extensionXMLList[0];
                     faultName = extensionXML["name"].toString();
                     extensionMessage = new WSDLMessage(faultName);
                     encoding = this.parseEncodingExtension(extensionXML,false,true);
                     extensionMessage.encoding = encoding;
                     operation.addFault(extensionMessage);
                  }
               }
               portType.addOperation(operation);
            }
            this.parsePortType(portTypeQName,portType);
         }
         else if(this.importsManager != null)
         {
            imports = this.importsManager.getResources();
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
         var portTypeXMLList:XMLList = this.xml.elements(this.wsdlConstants.portTypeQName);
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
            operationsXMLList = portTypeXML.elements(this.wsdlConstants.operationQName);
            for each(operationXML in operationsXMLList)
            {
               operationName = operationXML.@name.toString();
               operation = portType.getOperation(operationName);
               if(operation == null)
               {
                  this._log.warn("An operation \'{0}\' was found in the port type but is missing binding information.",operationName);
               }
               else
               {
                  inputXMLList = operationXML.elements(this.wsdlConstants.inputQName);
                  if(inputXMLList.length() > 0)
                  {
                     this.schemaManager.reset();
                     messageName = inputXMLList[0].@message.toString();
                     messageQName = this.schemaManager.getQNameForPrefixedName(messageName,inputXMLList[0]);
                     message = operation.inputMessage;
                     message.name = messageQName.localName;
                     this.parseMessage(message,messageQName,operationName,WSDLConstants.MODE_IN);
                  }
                  outputXMLList = operationXML.elements(this.wsdlConstants.outputQName);
                  if(outputXMLList.length() > 0)
                  {
                     this.schemaManager.reset();
                     messageName = outputXMLList[0].@message.toString();
                     messageQName = this.schemaManager.getQNameForPrefixedName(messageName,outputXMLList[0]);
                     message = operation.outputMessage;
                     message.name = messageQName.localName;
                     this.parseMessage(message,messageQName,operationName,WSDLConstants.MODE_OUT);
                  }
                  faultsXMLList = operationXML.elements(this.wsdlConstants.faultQName);
                  for each(faultXML in faultsXMLList)
                  {
                     this.schemaManager.reset();
                     faultName = faultXML.@name.toString();
                     message = operation.getFault(faultName);
                     if(message != null)
                     {
                        messageName = faultXML.@message.toString();
                        messageQName = this.schemaManager.getQNameForPrefixedName(messageName,faultXML);
                        this.parseMessage(message,messageQName,operationName,WSDLConstants.MODE_FAULT);
                     }
                  }
                  if(operation.style == SOAPConstants.DOC_STYLE)
                  {
                     this.parseDocumentOperation(operation);
                  }
               }
            }
         }
         else if(this.importsManager != null)
         {
            imports = this.importsManager.getResources();
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
         var messageXMLList:XMLList = this.xml.elements(this.wsdlConstants.messageQName);
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
            partXMLList = messageXML.elements(this.wsdlConstants.partQName);
            for each(partXML in partXMLList)
            {
               partName = partXML.@name;
               if(!(encoding != null && !encoding.hasPart(partName)))
               {
                  part = this.parseMessagePart(partXML);
                  message.addPart(part);
               }
            }
         }
         else if(this.importsManager != null)
         {
            imports = this.importsManager.getResources();
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
            elementQName = this.schemaManager.getQNameForPrefixedName(elementName,partXML);
            part.element = elementQName;
         }
         else if(partXMLType != "")
         {
            typeName = partXML.@type;
            typeQName = this.schemaManager.getQNameForPrefixedName(typeName,partXML);
            part.type = typeQName;
         }
         return part;
      }
      
      private function parseHeader(operationName:String, headerXML:XML) : WSDLMessage
      {
         var headerName:String = headerXML["part"].toString();
         var headerMessage:WSDLMessage = new WSDLMessage(headerName);
         var encoding:WSDLEncoding = this.parseEncodingExtension(headerXML,true);
         headerMessage.encoding = encoding;
         this.parseMessage(headerMessage,encoding.message,operationName,WSDLConstants.MODE_HEADER);
         return headerMessage;
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
            encoding.message = this.schemaManager.getQNameForPrefixedName(messageName,extensionXML);
            encoding.setParts(extensionXML["part"].toString());
         }
         else if(!isFault)
         {
            encoding.setParts(extensionXML["parts"].toString());
         }
         return encoding;
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
               this.schemaManager.reset();
               part = input.parts[0];
               if(part.element != null)
               {
                  element = this.schemaManager.getNamedDefinition(part.element,this.schemaConstants.elementTypeQName);
                  if(element != null && element["name"] == operation.name)
                  {
                     elementTypeString = element["type"];
                     if(elementTypeString != null && elementTypeString != "")
                     {
                        elementType = this.schemaManager.getQNameForPrefixedName(elementTypeString,element);
                        complexType = this.schemaManager.getNamedDefinition(elementType,this.schemaConstants.complexTypeQName);
                     }
                     else
                     {
                        complexTypes = element.elements(this.schemaConstants.complexTypeQName);
                        if(complexTypes.length() == 1)
                        {
                           complexType = complexTypes[0];
                        }
                     }
                     if(complexType != null)
                     {
                        attributes = complexType.elements(this.schemaConstants.attributeQName);
                        if(attributes.length() == 0)
                        {
                           sequences = complexType.elements(this.schemaConstants.sequenceQName);
                           if(complexType.elements().length() == 0 || sequences.length() == 1)
                           {
                              input.isWrapped = true;
                              input.wrappedQName = part.element;
                              input.parts = [];
                              if(sequences.length() == 1)
                              {
                                 sequence = sequences[0];
                                 requestElements = sequence.elements(this.schemaConstants.elementTypeQName);
                                 for each(requestElement in requestElements)
                                 {
                                    part = this.parseWrappedMessagePart(requestElement);
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
                  this.schemaManager.reset();
                  element = this.schemaManager.getNamedDefinition(part.element,this.schemaConstants.elementTypeQName);
                  if(element != null)
                  {
                     elementTypeString = element["type"];
                     if(elementTypeString != null && elementTypeString != "")
                     {
                        elementType = this.schemaManager.getQNameForPrefixedName(elementTypeString,element);
                        complexType = this.schemaManager.getNamedDefinition(elementType,this.schemaConstants.complexTypeQName);
                     }
                     else
                     {
                        complexTypes = element.elements(this.schemaConstants.complexTypeQName);
                        if(complexTypes.length() == 1)
                        {
                           complexType = complexTypes[0];
                        }
                     }
                     if(complexType != null)
                     {
                        attributes = complexType.elements(this.schemaConstants.attributeQName);
                        if(attributes.length() == 0)
                        {
                           sequences = complexType.elements(this.schemaConstants.sequenceQName);
                           if(complexType.elements().length() == 0 || sequences.length() == 1)
                           {
                              output.isWrapped = true;
                              output.wrappedQName = part.element;
                              output.parts = [];
                              if(sequences.length() == 1)
                              {
                                 sequence = sequences[0];
                                 resultElements = sequence.elements(this.schemaConstants.elementTypeQName);
                                 for each(resultElement in resultElements)
                                 {
                                    part = this.parseWrappedMessagePart(resultElement);
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
      
      private function parseWrappedMessagePart(elementXML:XML) : WSDLMessagePart
      {
         var ref:QName = null;
         var partType:String = null;
         if(elementXML.attribute("ref").length() == 1)
         {
            ref = this.schemaManager.getQNameForPrefixedName(elementXML.@ref,elementXML,true);
            elementXML = this.schemaManager.getNamedDefinition(ref,this.schemaConstants.elementTypeQName);
            if(elementXML == null)
            {
               throw new Error("Cannot resolve element definition for ref \'" + ref + "\'");
            }
         }
         var partName:String = elementXML.@name;
         var partQName:QName = this.schemaManager.getQNameForElement(partName,elementXML.@form);
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
                  part.type = this.schemaConstants.anyTypeQName;
               }
               else
               {
                  part.type = this.schemaManager.getQNameForPrefixedName(partType,elementXML);
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
            this.schemaManager.releaseScope();
         }
         return part;
      }
      
      private function processNamespaces() : void
      {
         var tns:String = null;
         var nsArray:Array = null;
         var ns:Namespace = null;
         if(this._xml != null)
         {
            tns = this._xml.@targetNamespace.toString();
            this._targetNamespace = new Namespace(tns);
            this.namespaces = {};
            nsArray = this._xml.namespaceDeclarations();
            for each(ns in nsArray)
            {
               this.namespaces[ns.prefix] = ns;
            }
            this._wsdlConstants = WSDLConstants.getConstants(this._xml);
            this._schemaConstants = SchemaConstants.getConstants(this._xml);
            this.schemaManager.addNamespaces(this.namespaces);
         }
      }
      
      private function processSchemas() : void
      {
         var schemas:XMLList = null;
         var schemaXML:XML = null;
         var schema:Schema = null;
         var types:XML = this.getTypes(this.targetNamespace);
         if(types != null)
         {
            schemas = types.elements(this.schemaConstants.schemaQName);
            for each(schemaXML in schemas)
            {
               schema = new Schema(schemaXML);
               this.addSchema(schema);
            }
         }
      }
   }
}

