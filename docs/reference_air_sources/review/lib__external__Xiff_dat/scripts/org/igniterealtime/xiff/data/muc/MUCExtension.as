package org.igniterealtime.xiff.data.muc
{
   import flash.xml.XMLNode;
   import org.igniterealtime.xiff.data.Extension;
   import org.igniterealtime.xiff.data.IExtension;
   import org.igniterealtime.xiff.data.ISerializable;
   
   public class MUCExtension extends Extension implements IExtension, ISerializable
   {
      
      public static var NS:String = "http://jabber.org/protocol/muc";
      
      public static var ELEMENT:String = "x";
      
      private var myHistoryNode:XMLNode;
      
      private var myPasswordNode:XMLNode;
      
      public function MUCExtension(param1:XMLNode = null)
      {
         super(param1);
      }
      
      public function getNS() : String
      {
         return MUCExtension.NS;
      }
      
      public function getElementName() : String
      {
         return MUCExtension.ELEMENT;
      }
      
      public function serialize(param1:XMLNode) : Boolean
      {
         var _loc3_:IExtension = null;
         if(exists(getNode().parentNode))
         {
            return false;
         }
         var _loc2_:XMLNode = getNode().cloneNode(true);
         for each(_loc3_ in getAllExtensions())
         {
            if(_loc3_ is ISerializable)
            {
               ISerializable(_loc3_).serialize(_loc2_);
            }
         }
         param1.appendChild(_loc2_);
         return true;
      }
      
      public function deserialize(param1:XMLNode) : Boolean
      {
         var _loc2_:XMLNode = null;
         setNode(param1);
         for each(_loc2_ in param1.childNodes)
         {
            switch(_loc2_.nodeName)
            {
               case "history":
                  this.myHistoryNode = _loc2_;
                  break;
               case "password":
                  this.myPasswordNode = _loc2_;
            }
         }
         return true;
      }
      
      public function addChildNode(param1:XMLNode) : void
      {
         getNode().appendChild(param1);
      }
      
      public function get password() : String
      {
         return this.myPasswordNode.firstChild.nodeValue;
      }
      
      public function set password(param1:String) : void
      {
         this.myPasswordNode = replaceTextNode(getNode(),this.myPasswordNode,"password",param1);
      }
      
      public function get history() : Boolean
      {
         return exists(this.myHistoryNode);
      }
      
      public function set history(param1:Boolean) : void
      {
         if(param1)
         {
            this.myHistoryNode = ensureNode(this.myHistoryNode,"history");
         }
         else
         {
            this.myHistoryNode.removeNode();
            this.myHistoryNode = null;
         }
      }
      
      public function get maxchars() : Number
      {
         return Number(this.myHistoryNode.attributes.maxchars);
      }
      
      public function set maxchars(param1:Number) : void
      {
         this.myHistoryNode = ensureNode(this.myHistoryNode,"history");
         this.myHistoryNode.attributes.maxchars = param1.toString();
      }
      
      public function get maxstanzas() : Number
      {
         return Number(this.myHistoryNode.attributes.maxstanzas);
      }
      
      public function set maxstanzas(param1:Number) : void
      {
         this.myHistoryNode = ensureNode(this.myHistoryNode,"history");
         this.myHistoryNode.attributes.maxstanzas = param1.toString();
      }
      
      public function get seconds() : Number
      {
         return Number(this.myHistoryNode.attributes.seconds);
      }
      
      public function set seconds(param1:Number) : void
      {
         this.myHistoryNode = ensureNode(this.myHistoryNode,"history");
         this.myHistoryNode.attributes.seconds = param1.toString();
      }
      
      public function get since() : String
      {
         return this.myHistoryNode.attributes.since;
      }
      
      public function set since(param1:String) : void
      {
         this.myHistoryNode = ensureNode(this.myHistoryNode,"history");
         this.myHistoryNode.attributes.since = param1;
      }
   }
}

