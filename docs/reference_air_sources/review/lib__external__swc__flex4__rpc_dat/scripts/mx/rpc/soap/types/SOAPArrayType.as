package mx.rpc.soap.types
{
   import mx.collections.IList;
   import mx.rpc.soap.SOAPConstants;
   import mx.rpc.soap.SOAPDecoder;
   import mx.rpc.soap.SOAPEncoder;
   import mx.rpc.wsdl.WSDLConstants;
   import mx.rpc.xml.ContentProxy;
   import mx.rpc.xml.SchemaConstants;
   import mx.rpc.xml.SchemaManager;
   import mx.rpc.xml.SchemaProcessor;
   import mx.rpc.xml.TypeIterator;
   import mx.utils.ObjectUtil;
   import mx.utils.StringUtil;
   
   [ExcludeClass]
   public class SOAPArrayType implements ICustomSOAPType
   {
      
      private var _dimensions:Array;
      
      private var dimensionString:String;
      
      private var itemName:QName;
      
      private var processor:SchemaProcessor;
      
      private var schemaConstants:SchemaConstants;
      
      private var schemaManager:SchemaManager;
      
      private var schemaTypeName:String;
      
      private var schemaType:QName;
      
      private var soapConstants:SOAPConstants;
      
      public function SOAPArrayType()
      {
         super();
         this.itemName = new QName("","item");
      }
      
      public function encode(encoder:SOAPEncoder, parent:XML, name:QName, value:*, restriction:XML = null) : void
      {
         var wsdlArrayType:String = null;
         this.processor = encoder;
         this.soapConstants = encoder.soapConstants;
         this.schemaManager = encoder.schemaManager;
         this.schemaConstants = this.schemaManager.schemaConstants;
         value = this.unwrapMXMLArray(value);
         if(restriction != null)
         {
            wsdlArrayType = this.determineWSDLArrayType(restriction,encoder.wsdlOperation.wsdlConstants);
            this.parseWSDLArrayType(wsdlArrayType);
         }
         this.schemaType = this.schemaManager.getQNameForPrefixedName(this.schemaTypeName,restriction);
         parent.addNamespace(this.soapConstants.encodingNamespace);
         this.encodeDimensionInformation(parent,this.dimensionString);
         this.encodeArray(parent,this.dimensions,value);
      }
      
      public function decode(decoder:SOAPDecoder, parent:*, name:*, value:*, restriction:XML = null) : void
      {
         var arrayTypeString:String = null;
         var wsdlArrayType:String = null;
         var proxy:ContentProxy = null;
         this.processor = decoder;
         this.soapConstants = decoder.soapConstants;
         this.schemaManager = decoder.schemaManager;
         this.schemaConstants = this.schemaManager.schemaConstants;
         var valueXML:XML = value as XML;
         if(valueXML != null)
         {
            arrayTypeString = valueXML[this.soapConstants.soapencArrayTypeQName];
            if(arrayTypeString != null && arrayTypeString != "")
            {
               this.parseWSDLArrayType(arrayTypeString);
               this.schemaType = this.schemaManager.getQNameForPrefixedName(this.schemaTypeName,valueXML);
            }
         }
         if(this.schemaType == null && restriction != null)
         {
            wsdlArrayType = this.determineWSDLArrayType(restriction,decoder.wsdlOperation.wsdlConstants);
            this.parseWSDLArrayType(wsdlArrayType);
            this.schemaType = this.schemaManager.getQNameForPrefixedName(this.schemaTypeName,restriction);
         }
         if(this.schemaType != null)
         {
            if(parent is ContentProxy)
            {
               proxy = parent as ContentProxy;
               proxy.isSimple = false;
               if(!(proxy.content is IList) && !(proxy.content is Array))
               {
                  proxy.content = decoder.createIterableValue();
               }
            }
            this.decodeArray(parent,this.dimensions,value,decoder.makeObjectsBindable);
         }
      }
      
      private function encodeArray(parent:XML, dimensions:Array, value:*) : void
      {
         var entry:* = undefined;
         var dimensionSize:int = 0;
         var itemValue:* = undefined;
         var nestedDimension:Array = null;
         var nestedDimensionString:String = null;
         var nestedArray:XML = null;
         var i:uint = 0;
         var typeAttr:String = this.schemaConstants.getXSIToken(this.schemaConstants.typeAttrQName);
         parent[typeAttr] = this.soapConstants.getSOAPEncodingToken(this.soapConstants.soapencArrayQName);
         if(!TypeIterator.isIterable(value))
         {
            value = [value];
         }
         var iter:TypeIterator = new TypeIterator(value);
         var d:uint = 0;
         if(dimensions.length > 0)
         {
            entry = dimensions[0];
            if(!(entry is Array))
            {
               entry = [entry];
            }
            for each(dimensionSize in entry)
            {
               d++;
               if(dimensionSize < 0)
               {
                  if(dimensions.length == 1)
                  {
                     while(iter.hasNext())
                     {
                        itemValue = iter.next();
                        nestedArray = new XML("<" + this.itemName.localName + "/>");
                        this.encodeArrayItem(nestedArray,itemValue);
                        parent.appendChild(nestedArray);
                     }
                  }
                  else if(dimensions.length > 1)
                  {
                     nestedDimensionString = "[]";
                     while(iter.hasNext())
                     {
                        itemValue = iter.next();
                        nestedDimension = dimensions[d];
                        nestedArray = new XML("<" + this.itemName.localName + "/>");
                        this.encodeDimensionInformation(nestedArray,nestedDimensionString);
                        this.encodeArray(nestedArray,nestedDimension,itemValue);
                        parent.appendChild(nestedArray);
                     }
                  }
               }
               else
               {
                  for(i = 0; i < dimensionSize; i++)
                  {
                     itemValue = TypeIterator.getItemAt(iter.value,i);
                     if(dimensions.length == 1)
                     {
                        nestedArray = new XML("<" + this.itemName.localName + "/>");
                        this.encodeArrayItem(nestedArray,itemValue);
                        parent.appendChild(nestedArray);
                     }
                     else if(dimensions.length > 1)
                     {
                        nestedDimensionString = "[" + dimensionSize + "]";
                        nestedDimension = dimensions[d];
                        nestedArray = new XML("<" + this.itemName.localName + "/>");
                        this.encodeDimensionInformation(nestedArray,nestedDimensionString);
                        this.encodeArray(nestedArray,nestedDimension,itemValue);
                        parent.appendChild(nestedArray);
                     }
                  }
               }
            }
         }
      }
      
      private function decodeArray(parent:*, dimensions:Array, value:*, makeObjectsBindable:Boolean) : void
      {
         var dataXML:XML = null;
         var entry:* = undefined;
         var dimensionSize:int = 0;
         var itemValue:* = undefined;
         var nestedDimension:Array = null;
         var nestedArray:* = undefined;
         var i:uint = 0;
         if(value is XML)
         {
            dataXML = value as XML;
            value = dataXML.elements();
         }
         if(!TypeIterator.isIterable(value) && value != "")
         {
            value = [value];
         }
         var iter:TypeIterator = new TypeIterator(value);
         var d:uint = 0;
         if(dimensions.length > 0)
         {
            entry = dimensions[0];
            if(!(entry is Array))
            {
               entry = [entry];
            }
            for each(dimensionSize in entry)
            {
               d++;
               if(dimensionSize < 0)
               {
                  if(dimensions.length == 1)
                  {
                     while(iter.hasNext())
                     {
                        itemValue = iter.next();
                        this.decodeArrayItem(parent,itemValue);
                     }
                  }
                  else if(dimensions.length > 1)
                  {
                     while(iter.hasNext())
                     {
                        itemValue = iter.next();
                        nestedDimension = dimensions[d];
                        nestedArray = SOAPDecoder(this.processor).createIterableValue(this.schemaType);
                        this.decodeArray(nestedArray,nestedDimension,itemValue,makeObjectsBindable);
                        TypeIterator.push(parent,nestedArray);
                     }
                  }
               }
               else
               {
                  for(i = 0; i < dimensionSize; i++)
                  {
                     itemValue = TypeIterator.getItemAt(iter.value,i);
                     if(dimensions.length == 1)
                     {
                        this.decodeArrayItem(parent,itemValue);
                     }
                     else if(dimensions.length > 1)
                     {
                        nestedDimension = dimensions[d];
                        nestedArray = SOAPDecoder(this.processor).createIterableValue(this.schemaType);
                        this.decodeArray(nestedArray,nestedDimension,itemValue,makeObjectsBindable);
                        TypeIterator.push(parent,nestedArray);
                     }
                  }
               }
            }
         }
      }
      
      private function encodeArrayItem(item:XML, value:*) : void
      {
         var encoder:SOAPEncoder = this.processor as SOAPEncoder;
         encoder.encodeType(this.schemaType,item,this.itemName,value);
      }
      
      private function decodeArrayItem(parent:*, value:*) : void
      {
         var decoder:SOAPDecoder = this.processor as SOAPDecoder;
         var item:* = decoder.createContent(this.schemaType);
         decoder.decodeType(this.schemaType,item,this.itemName,value);
         decoder.setValue(parent,this.itemName,item,this.schemaType);
      }
      
      private function encodeDimensionInformation(parent:XML, dimensionString:String) : void
      {
         var uri:String = this.schemaType.uri;
         var prefix:String = this.schemaManager.getOrCreatePrefix(uri);
         var ns:Namespace = new Namespace(prefix,uri);
         var arrayTypeString:String = prefix + ":" + this.schemaType.localName;
         arrayTypeString += dimensionString;
         parent.addNamespace(ns);
         var arrayTypeAttr:String = this.soapConstants.getSOAPEncodingToken(this.soapConstants.soapencArrayTypeQName);
         parent[arrayTypeAttr] = arrayTypeString;
      }
      
      private function getSingleElementFromNode(node:XML, ... types) : XML
      {
         var element:XML = null;
         var type:QName = null;
         var elements:XMLList = node.elements();
         loop0:
         for each(element in elements)
         {
            if(types != null && types.length > 0)
            {
               var _loc8_:int = 0;
               var _loc9_:* = types;
               do
               {
                  for each(type in _loc9_)
                  {
                  }
                  continue loop0;
               }
               while(element.name() != type);
               return element;
            }
            return element;
         }
         return null;
      }
      
      private function determineWSDLArrayType(restriction:XML, wsdlConstants:WSDLConstants) : String
      {
         var soapencArrayTypeRef:String = null;
         var soapencArrayType:QName = null;
         var arrayTypeString:String = "";
         var attribute:XML = this.getSingleElementFromNode(restriction,this.schemaConstants.attributeQName);
         if(attribute != null)
         {
            soapencArrayTypeRef = attribute.@ref;
            soapencArrayType = this.schemaManager.getQNameForPrefixedName(soapencArrayTypeRef,attribute,true);
            if(soapencArrayType == this.soapConstants.soapencArrayTypeQName)
            {
               arrayTypeString = attribute.attribute(wsdlConstants.wsdlArrayTypeQName).toString();
            }
         }
         return arrayTypeString;
      }
      
      private function parseWSDLArrayType(wsdlArrayType:String) : void
      {
         var typeName:String = null;
         var dimsString:String = null;
         var newDimension:Array = null;
         var startBracket:int = wsdlArrayType.indexOf("[");
         var endBracket:int = -1;
         if(startBracket > 0)
         {
            this.dimensionString = wsdlArrayType.substring(startBracket);
            this.schemaTypeName = StringUtil.trim(wsdlArrayType.substring(0,startBracket));
            endBracket = wsdlArrayType.indexOf("]",startBracket);
         }
         if(startBracket < 0 || endBracket < 0)
         {
            throw new Error("Invalid SOAP-encoded Array type \'" + wsdlArrayType + "\'.");
         }
         var rankOrSizeString:String = StringUtil.trim(wsdlArrayType.substring(startBracket));
         var dimsArray:Array = rankOrSizeString.split("[");
         var currentDimension:Array = this.dimensions;
         for(var i:int = dimsArray.length - 1; i >= 0; i--)
         {
            dimsString = dimsArray[i] as String;
            if(dimsString.length > 0)
            {
               if(currentDimension.length > 0)
               {
                  newDimension = [];
                  currentDimension.push(newDimension);
                  currentDimension = newDimension;
               }
               this.parseDimensions(wsdlArrayType,dimsString,currentDimension);
            }
         }
      }
      
      private function parseDimensions(wsdlArrayType:String, dimensionsString:String, currentDimension:Array) : void
      {
         var dim:Number = NaN;
         var dimString:String = null;
         if(dimensionsString.charAt(0) == "[")
         {
            dimensionsString = dimensionsString.substring(1);
         }
         if(dimensionsString.charAt(dimensionsString.length - 1) == "]")
         {
            dimensionsString = dimensionsString.substring(0,dimensionsString.length - 1);
         }
         var dimensions:Array = dimensionsString.split(",");
         if(dimensions.length > 0)
         {
            for each(dimString in dimensions)
            {
               if(dimString.length > 0)
               {
                  dim = parseInt(dimString);
                  if(!(!isNaN(dim) && dim < int.MAX_VALUE))
                  {
                     throw new Error("Invalid dimension \'" + dimString + "\' for SOAP encoded Array type \'" + wsdlArrayType + "\'.");
                  }
                  currentDimension.push(int(dim));
               }
               else
               {
                  currentDimension.push(-1);
               }
            }
         }
      }
      
      private function unwrapMXMLArray(value:*) : *
      {
         var classInfo:Object = null;
         var properties:Array = null;
         var property:String = null;
         var childValue:* = undefined;
         var result:* = value;
         if(!(value is Array))
         {
            try
            {
               classInfo = ObjectUtil.getClassInfo(value as Object);
               properties = classInfo["properties"];
               if(properties.length == 1)
               {
                  property = properties[0];
                  if(property != null && Boolean(value.hasOwnProperty(property)))
                  {
                     childValue = value[property];
                     if(childValue is Array)
                     {
                        result = childValue;
                     }
                  }
               }
            }
            catch(e:Error)
            {
            }
         }
         return result;
      }
      
      private function get dimensions() : Array
      {
         if(this._dimensions == null)
         {
            this._dimensions = [];
         }
         return this._dimensions;
      }
   }
}

