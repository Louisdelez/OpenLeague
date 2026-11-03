package mx.rpc.xml
{
   import mx.utils.URLUtil;
   
   [ExcludeClass]
   public class SchemaProcessor
   {
      
      protected var strictOccurenceBounds:Boolean = false;
      
      private var _schemaManager:SchemaManager;
      
      public function SchemaProcessor()
      {
         super();
      }
      
      public function get schemaManager() : SchemaManager
      {
         if(this._schemaManager == null)
         {
            this._schemaManager = new SchemaManager();
         }
         return this._schemaManager;
      }
      
      public function set schemaManager(manager:SchemaManager) : void
      {
         this._schemaManager = manager;
      }
      
      protected function get constants() : SchemaConstants
      {
         return this.schemaManager.schemaConstants;
      }
      
      public function reset() : void
      {
         this.schemaManager.reset();
      }
      
      public function isBuiltInType(type:QName) : Boolean
      {
         var uri:String = type != null ? type.uri : null;
         if(uri != null)
         {
            if(URLUtil.urisEqual(uri,SchemaConstants.XSD_URI_1999) || URLUtil.urisEqual(uri,SchemaConstants.XSD_URI_2000) || URLUtil.urisEqual(uri,SchemaConstants.XSD_URI_2001))
            {
               return true;
            }
         }
         return false;
      }
      
      public function getValueOccurence(value:*) : uint
      {
         var result:uint = 1;
         if(value != null && TypeIterator.isIterable(value))
         {
            result = TypeIterator.getLength(value);
         }
         else if(value === undefined)
         {
            result = 0;
         }
         return result;
      }
      
      protected function getAttributeFromNode(name:*, node:XML) : String
      {
         var value:String = null;
         var attribute:XMLList = null;
         if(node != null)
         {
            attribute = node.attribute(name);
            if(attribute.length() > 0)
            {
               value = attribute[0];
            }
         }
         return value;
      }
      
      protected function getSingleElementFromNode(node:XML, ... types) : XML
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
      
      protected function getMaxOccurs(definition:XML) : uint
      {
         var maxOccurs:uint = 1;
         var attributeValue:String = this.getAttributeFromNode("maxOccurs",definition);
         if(attributeValue != null)
         {
            maxOccurs = attributeValue == "unbounded" ? uint.MAX_VALUE : uint(parseInt(attributeValue));
         }
         return maxOccurs;
      }
      
      protected function getMinOccurs(definition:XML) : uint
      {
         var minOccurs:uint = 1;
         var attributeValue:String = this.getAttributeFromNode("minOccurs",definition);
         if(attributeValue != null)
         {
            minOccurs = parseInt(attributeValue);
         }
         return minOccurs;
      }
   }
}

