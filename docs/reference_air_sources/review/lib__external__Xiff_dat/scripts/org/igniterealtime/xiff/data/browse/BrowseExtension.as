package org.igniterealtime.xiff.data.browse
{
   import flash.xml.XMLNode;
   import org.igniterealtime.xiff.data.ExtensionClassRegistry;
   import org.igniterealtime.xiff.data.IExtension;
   import org.igniterealtime.xiff.data.ISerializable;
   
   public class BrowseExtension extends BrowseItem implements IExtension, ISerializable
   {
      
      public static var NS:String = "jabber:iq:browse";
      
      public static var ELEMENT:String = "query";
      
      private static var staticDepends:Class = ExtensionClassRegistry;
      
      private var myItems:Array;
      
      public function BrowseExtension(param1:XMLNode = null)
      {
         super(param1);
         getNode().attributes.xmlns = this.getNS();
         getNode().nodeName = this.getElementName();
         this.myItems = new Array();
      }
      
      public static function enable() : void
      {
         ExtensionClassRegistry.register(BrowseExtension);
      }
      
      public function getNS() : String
      {
         return BrowseExtension.NS;
      }
      
      public function getElementName() : String
      {
         return BrowseExtension.ELEMENT;
      }
      
      public function addItem(param1:BrowseItem) : BrowseItem
      {
         this.myItems.push(param1);
         return param1;
      }
      
      public function get items() : Array
      {
         return this.myItems;
      }
      
      override public function serialize(param1:XMLNode) : Boolean
      {
         var _loc3_:BrowseItem = null;
         var _loc2_:XMLNode = getNode();
         for each(_loc3_ in this.myItems)
         {
            _loc3_.serialize(_loc2_);
         }
         if(!exists(_loc2_.parentNode))
         {
            param1.appendChild(_loc2_.cloneNode(true));
         }
         return true;
      }
      
      override public function deserialize(param1:XMLNode) : Boolean
      {
         var _loc2_:XMLNode = null;
         var _loc3_:BrowseItem = null;
         setNode(param1);
         this["deserialized"] = true;
         this.myItems = [];
         for each(_loc2_ in param1.childNodes)
         {
            switch(_loc2_.nodeName)
            {
               case "item":
                  _loc3_ = new BrowseItem(getNode());
                  _loc3_.deserialize(_loc2_);
                  this.myItems.push(_loc3_);
            }
         }
         return true;
      }
   }
}

