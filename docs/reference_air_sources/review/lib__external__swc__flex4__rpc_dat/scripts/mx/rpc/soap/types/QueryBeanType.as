package mx.rpc.soap.types
{
   import mx.rpc.soap.SOAPDecoder;
   import mx.rpc.soap.SOAPEncoder;
   import mx.rpc.xml.TypeIterator;
   import mx.rpc.xml.XMLDecoder;
   import mx.utils.ObjectProxy;
   
   [ExcludeClass]
   public class QueryBeanType implements ICustomSOAPType
   {
      
      public function QueryBeanType()
      {
         super();
      }
      
      public function encode(encoder:SOAPEncoder, parent:XML, name:QName, value:*, restriction:XML = null) : void
      {
         throw new Error("Unsupported operation - Query Beans cannot be sent to ColdFusion.");
      }
      
      public function decode(decoder:SOAPDecoder, parent:*, name:*, value:*, restriction:XML = null) : void
      {
         var returnVal:* = undefined;
         var columnName:XML = null;
         var dataXML:XML = null;
         var item:* = undefined;
         var resultItem:* = undefined;
         var i:uint = 0;
         var beanXML:XML = value as XML;
         if(decoder.makeObjectsBindable)
         {
            returnVal = new XMLDecoder.listClass();
         }
         else
         {
            returnVal = [];
         }
         var colXML:XML = beanXML.columnList[0];
         if(colXML == null)
         {
            return;
         }
         var columnsXMLList:XMLList = colXML.elements();
         var columnNames:Array = [];
         for each(columnName in columnsXMLList)
         {
            columnNames.push(columnName.toString());
         }
         dataXML = beanXML.data[0];
         if(dataXML == null)
         {
            return;
         }
         var soapArrayType:SOAPArrayType = new SOAPArrayType();
         var tempParent:Array = [];
         soapArrayType.decode(decoder,tempParent,name,dataXML,restriction);
         var iterator:TypeIterator = new TypeIterator(tempParent);
         while(iterator.hasNext())
         {
            item = iterator.next();
            if(decoder.makeObjectsBindable)
            {
               resultItem = new ObjectProxy();
            }
            else
            {
               resultItem = {};
            }
            for(i = 0; i < columnNames.length; i++)
            {
               resultItem[columnNames[i]] = item[i];
            }
            TypeIterator.push(returnVal,resultItem);
         }
         decoder.setValue(parent,name,returnVal);
      }
   }
}

