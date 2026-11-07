package mx.rpc.soap.types
{
   import flash.utils.ByteArray;
   import mx.rpc.soap.SOAPDecoder;
   import mx.rpc.soap.SOAPEncoder;
   import mx.rpc.xml.ContentProxy;
   import mx.rpc.xml.SchemaConstants;
   import mx.rpc.xml.SchemaDatatypes;
   import mx.rpc.xml.SchemaMarshaller;
   
   [ExcludeClass]
   public class MapType implements ICustomSOAPType
   {
      
      public static var itemQName:QName = new QName("","item");
      
      public static var keyQName:QName = new QName("","key");
      
      public static var valueQName:QName = new QName("","value");
      
      public function MapType()
      {
         super();
      }
      
      public function decode(decoder:SOAPDecoder, parent:*, name:*, value:*, restriction:XML = null) : void
      {
         var item:XML = null;
         var key:Object = null;
         var itemValue:Object = null;
         var itemChild:XML = null;
         var typeName:String = null;
         var type:QName = null;
         if(parent is ContentProxy)
         {
            parent.isSimple = false;
         }
         var constants:SchemaConstants = decoder.schemaManager.schemaConstants;
         var mapValue:XML = value as XML;
         loop0:
         for each(item in mapValue.elements())
         {
            var _loc16_:int = 0;
            var _loc17_:* = item.elements();
            loop1:
            while(true)
            {
               for each(itemChild in _loc17_)
               {
                  typeName = itemChild.attribute(constants.typeAttrQName);
                  if(typeName != null && typeName != "")
                  {
                     type = decoder.schemaManager.getQNameForPrefixedName(typeName,itemChild);
                  }
                  else
                  {
                     type = constants.anyTypeQName;
                  }
                  if(itemChild.localName() == "key")
                  {
                     key = decoder.createContent();
                     decoder.decodeType(type,key,itemChild.name(),itemChild);
                  }
                  else
                  {
                     if(itemChild.localName() != "value")
                     {
                        break loop1;
                     }
                     itemValue = decoder.createContent();
                     decoder.decodeType(type,itemValue,itemChild.name(),itemChild);
                  }
               }
               decoder.setValue(parent,key,itemValue);
               continue loop0;
            }
            throw new Error("Apache Map datatype must only contain key/value pairs.");
         }
      }
      
      public function encode(encoder:SOAPEncoder, parent:XML, name:QName, value:*, restriction:XML = null) : void
      {
         var item:String = null;
         var itemNode:XML = null;
         var keyNode:XML = null;
         var valueNode:XML = null;
         var keyValue:Object = null;
         var typeLocalName:String = null;
         var constants:SchemaConstants = null;
         var type:QName = null;
         var datatypes:SchemaDatatypes = encoder.schemaManager.schemaDatatypes;
         for(item in value)
         {
            itemNode = encoder.createElement(itemQName);
            keyNode = encoder.createElement(keyQName);
            valueNode = encoder.createElement(valueQName);
            if(item != null)
            {
               encoder.encodeType(datatypes.stringQName,keyNode,keyQName,item);
            }
            else
            {
               encoder.setValue(keyNode,null);
            }
            encoder.setValue(itemNode,keyNode);
            keyValue = value[item];
            if(keyValue != null)
            {
               typeLocalName = "string";
               if(keyValue is Number)
               {
                  if(keyValue is uint)
                  {
                     typeLocalName = "unsignedInt";
                  }
                  else if(keyValue is int)
                  {
                     typeLocalName = "int";
                  }
                  else
                  {
                     typeLocalName = "double";
                  }
               }
               else if(keyValue is Boolean)
               {
                  typeLocalName = "boolean";
               }
               else if(keyValue is String)
               {
                  typeLocalName = "string";
               }
               else if(keyValue is ByteArray)
               {
                  if(SchemaMarshaller.byteArrayAsBase64Binary)
                  {
                     typeLocalName = "base64Binary";
                  }
                  else
                  {
                     typeLocalName = "hexBinary";
                  }
               }
               else if(keyValue is Date)
               {
                  typeLocalName = "dateTime";
               }
               constants = encoder.schemaManager.schemaConstants;
               type = typeLocalName != null ? new QName(constants.xsdURI,typeLocalName) : null;
               encoder.encodeType(type,valueNode,valueQName,keyValue);
            }
            else
            {
               encoder.setValue(valueNode,null);
            }
            encoder.setValue(itemNode,valueNode);
            encoder.setValue(parent,itemNode);
         }
      }
   }
}

