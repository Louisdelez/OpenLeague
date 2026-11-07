package org.igniterealtime.xiff.data.search
{
   import flash.xml.XMLNode;
   import org.igniterealtime.xiff.data.Extension;
   import org.igniterealtime.xiff.data.ExtensionClassRegistry;
   import org.igniterealtime.xiff.data.IExtension;
   import org.igniterealtime.xiff.data.ISerializable;
   import org.igniterealtime.xiff.data.forms.FormExtension;
   
   public class SearchExtension extends Extension implements IExtension, ISerializable
   {
      
      public static var NS:String = "jabber:iq:search";
      
      public static var ELEMENT:String = "query";
      
      private static var staticDepends:Class = ExtensionClassRegistry;
      
      private var myFields:Object;
      
      private var myInstructionsNode:XMLNode;
      
      private var myItems:Array = [];
      
      public function SearchExtension(param1:XMLNode = null)
      {
         super(param1);
         this.myFields = new Object();
      }
      
      public static function enable() : void
      {
         ExtensionClassRegistry.register(SearchExtension);
      }
      
      public function getNS() : String
      {
         return SearchExtension.NS;
      }
      
      public function getElementName() : String
      {
         return SearchExtension.ELEMENT;
      }
      
      public function serialize(param1:XMLNode) : Boolean
      {
         if(!exists(getNode().parentNode))
         {
            param1.appendChild(getNode().cloneNode(true));
         }
         return true;
      }
      
      public function deserialize(param1:XMLNode) : Boolean
      {
         var _loc3_:String = null;
         var _loc4_:SearchItem = null;
         var _loc5_:FormExtension = null;
         setNode(param1);
         var _loc2_:Array = getNode().childNodes;
         for(_loc3_ in _loc2_)
         {
            switch(_loc2_[_loc3_].nodeName)
            {
               case "instructions":
                  this.myInstructionsNode = _loc2_[_loc3_];
                  break;
               case "x":
                  if(_loc2_[_loc3_].namespaceURI == FormExtension.NS)
                  {
                     _loc5_ = new FormExtension(getNode());
                     _loc5_.deserialize(_loc2_[_loc3_]);
                     this.addExtension(_loc5_);
                  }
                  break;
               case "item":
                  _loc4_ = new SearchItem(getNode());
                  _loc4_.deserialize(_loc2_[_loc3_]);
                  this.myItems.push(_loc4_);
                  break;
               default:
                  this.myFields[_loc2_[_loc3_].nodeName] = _loc2_[_loc3_];
            }
         }
         return true;
      }
      
      public function getRequiredFieldNames() : Array
      {
         var _loc2_:String = null;
         var _loc1_:Array = new Array();
         for(_loc2_ in this.myFields)
         {
            _loc1_.push(_loc2_);
         }
         return _loc1_;
      }
      
      public function getAllItems() : Array
      {
         return this.myItems;
      }
      
      public function get instructions() : String
      {
         return this.myInstructionsNode.firstChild.nodeValue;
      }
      
      public function set instructions(param1:String) : void
      {
         this.myInstructionsNode = replaceTextNode(getNode(),this.myInstructionsNode,"instructions",param1);
      }
      
      public function getField(param1:String) : String
      {
         return this.myFields[param1].firstChild.nodeValue;
      }
      
      public function setField(param1:String, param2:String) : void
      {
         this.myFields[param1] = replaceTextNode(getNode(),this.myFields[param1],param1,param2);
      }
   }
}

