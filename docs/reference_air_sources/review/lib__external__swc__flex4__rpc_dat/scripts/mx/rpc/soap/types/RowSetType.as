package mx.rpc.soap.types
{
   import mx.rpc.soap.SOAPDecoder;
   import mx.rpc.soap.SOAPEncoder;
   import mx.rpc.xml.ContentProxy;
   
   [ExcludeClass]
   public class RowSetType implements ICustomSOAPType
   {
      
      public function RowSetType()
      {
         super();
      }
      
      public function encode(encoder:SOAPEncoder, parent:XML, name:QName, value:*, restriction:XML = null) : void
      {
         throw new Error("Unsupported operation - RowSet cannot be sent to a server.");
      }
      
      public function decode(decoder:SOAPDecoder, parent:*, name:*, value:*, restriction:XML = null) : void
      {
         var i:uint = 0;
         var field:XML = null;
         var items:XMLList = null;
         var item:XML = null;
         var typeAttr:String = null;
         var typeQName:QName = null;
         var columns:XMLList = null;
         var row:* = undefined;
         var j:uint = 0;
         var column:XML = null;
         if(parent is ContentProxy)
         {
            parent.isSimple = false;
         }
         var rowSetNode:XML = value as XML;
         var returnVal:Array = [];
         var types:Array = [];
         var fields:Array = [];
         var fieldNodes:XMLList = rowSetNode.elements()[0].elements();
         for each(field in fieldNodes)
         {
            typeAttr = field.attribute("type").toString();
            if(typeAttr != null && typeAttr != "")
            {
               typeQName = decoder.schemaManager.getQNameForPrefixedName(typeAttr,field);
            }
            if(typeQName == null)
            {
               typeQName = decoder.schemaManager.schemaDatatypes.stringQName;
            }
            types[i] = typeQName;
            fields[i] = field.text().toString();
            i++;
         }
         items = rowSetNode.elements()[1].elements();
         i = 0;
         for each(item in items)
         {
            columns = item.elements();
            row = decoder.createContent();
            j = 0;
            for each(column in columns)
            {
               row[fields[j]] = decoder.decode(column,null,types[j] as QName);
               j++;
            }
            returnVal[i] = row;
            i++;
         }
         decoder.setValue(parent,name,returnVal);
      }
   }
}

