package mx.rpc.soap.types
{
   import mx.rpc.soap.SOAPConstants;
   import mx.rpc.soap.SOAPDecoder;
   import mx.rpc.soap.SOAPEncoder;
   import mx.rpc.xml.ContentProxy;
   import mx.rpc.xml.Schema;
   import mx.rpc.xml.SchemaConstants;
   import mx.rpc.xml.TypeIterator;
   
   [ExcludeClass]
   public class DataSetType implements ICustomSOAPType
   {
      
      private var schemaConstants:SchemaConstants;
      
      public function DataSetType()
      {
         super();
      }
      
      public function encode(encoder:SOAPEncoder, parent:XML, name:QName, value:*, restriction:XML = null) : void
      {
         throw new Error("Unsupported operation - .NET DataSet diffgrams cannot be sent from client.");
      }
      
      public function decode(decoder:SOAPDecoder, parent:*, name:*, value:*, restriction:XML = null) : void
      {
         var tblName:String = null;
         var tableObj:* = undefined;
         var schema:Schema = null;
         var rowXML:XML = null;
         var rowObj:* = undefined;
         if(parent is ContentProxy)
         {
            ContentProxy(parent).isSimple = false;
         }
         this.schemaConstants = decoder.schemaConstants;
         var schemaXML:XML = XML(value).elements(this.schemaConstants.schemaQName)[0];
         var rootDataXML:XML = XML(value).elements(SOAPConstants.diffgramQName)[0].elements()[0];
         var dataSet:* = parent;
         var tableDefinitions:Object = this.processTables(schemaXML);
         var tableCollection:* = decoder.createContent();
         if(tableCollection is ContentProxy)
         {
            ContentProxy(tableCollection).isSimple = false;
         }
         for(tblName in tableDefinitions)
         {
            tableObj = decoder.createContent();
            if(tableObj is ContentProxy)
            {
               ContentProxy(tableObj).isSimple = false;
            }
            decoder.setValue(tableObj,"Columns",this.processColumns(decoder,tableDefinitions[tblName]));
            decoder.setValue(tableObj,"Rows",decoder.createIterableValue());
            decoder.setValue(tableCollection,tblName,tableObj);
         }
         if(rootDataXML != null)
         {
            schema = new Schema(schemaXML);
            decoder.schemaManager.addSchema(schema,false);
            for(tblName in tableCollection)
            {
               for each(rowXML in rootDataXML.elements(tblName))
               {
                  rowObj = decoder.decode(rowXML,rowXML.name(),null,tableDefinitions[tblName]);
                  TypeIterator.push(tableCollection[tblName]["Rows"],rowObj);
               }
            }
            decoder.schemaManager.releaseScope();
         }
         decoder.setValue(dataSet,"Tables",tableCollection);
      }
      
      private function processTables(schemaXML:XML) : Object
      {
         var tblXML:XML = null;
         var tblsXMLList:XMLList = schemaXML.elements(this.schemaConstants.elementTypeQName)[0].elements(this.schemaConstants.complexTypeQName)[0].elements(this.schemaConstants.choiceQName)[0].elements(this.schemaConstants.elementTypeQName);
         var tables:Object = {};
         for each(tblXML in tblsXMLList)
         {
            tables[tblXML.attribute("name")] = tblXML;
         }
         return tables;
      }
      
      private function processColumns(decoder:SOAPDecoder, tableXML:XML) : *
      {
         var colXML:XML = null;
         var colsXMLList:XMLList = tableXML.elements(this.schemaConstants.complexTypeQName)[0].elements(this.schemaConstants.sequenceQName)[0].elements(this.schemaConstants.elementTypeQName);
         var columns:* = decoder.createIterableValue();
         for each(colXML in colsXMLList)
         {
            TypeIterator.push(columns,colXML.attribute("name").toString());
         }
         return columns;
      }
   }
}

