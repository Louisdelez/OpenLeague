package org.igniterealtime.xiff.data.disco
{
   import flash.xml.XMLNode;
   import org.igniterealtime.xiff.data.ExtensionClassRegistry;
   import org.igniterealtime.xiff.data.IExtension;
   
   public class ItemDiscoExtension extends DiscoExtension implements IExtension
   {
      
      public static const NS:String = "http://jabber.org/protocol/disco#items";
      
      private var myItems:Array;
      
      public function ItemDiscoExtension(param1:XMLNode = null)
      {
         super(param1);
      }
      
      public static function enable() : void
      {
         ExtensionClassRegistry.register(ItemDiscoExtension);
      }
      
      public function getElementName() : String
      {
         return DiscoExtension.ELEMENT;
      }
      
      public function getNS() : String
      {
         return ItemDiscoExtension.NS;
      }
      
      public function get items() : Array
      {
         return this.myItems;
      }
      
      override public function deserialize(param1:XMLNode) : Boolean
      {
         var _loc2_:XMLNode = null;
         if(!super.deserialize(param1))
         {
            return false;
         }
         this.myItems = [];
         for each(_loc2_ in getNode().childNodes)
         {
            this.myItems.push(_loc2_.attributes);
         }
         return true;
      }
   }
}

