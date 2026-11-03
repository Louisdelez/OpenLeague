package org.igniterealtime.xiff.data.search
{
   import flash.xml.XMLNode;
   import org.igniterealtime.xiff.data.ISerializable;
   import org.igniterealtime.xiff.data.XMLStanza;
   
   public class SearchItem extends XMLStanza implements ISerializable
   {
      
      public static var ELEMENT:String = "item";
      
      private var myFields:Object;
      
      public function SearchItem(param1:XMLNode = null)
      {
         super();
         this.myFields = new Object();
         getNode().nodeName = ELEMENT;
         if(exists(param1))
         {
            param1.appendChild(getNode());
         }
      }
      
      public function serialize(param1:XMLNode) : Boolean
      {
         if(param1 != getNode().parentNode)
         {
            param1.appendChild(getNode().cloneNode(true));
         }
         return true;
      }
      
      public function deserialize(param1:XMLNode) : Boolean
      {
         var _loc3_:String = null;
         setNode(param1);
         var _loc2_:Array = param1.childNodes;
         for(_loc3_ in _loc2_)
         {
            this.myFields[_loc2_[_loc3_].nodeName.toLowerCase()] = _loc2_[_loc3_];
         }
         return true;
      }
      
      public function getField(param1:String) : String
      {
         if(this.myFields[param1] != null && this.myFields[param1].firstChild != null)
         {
            return this.myFields[param1].firstChild.nodeValue;
         }
         return null;
      }
      
      public function setField(param1:String, param2:String) : void
      {
         this.myFields[param1] = replaceTextNode(getNode(),this.myFields[param1],param1,param2);
      }
      
      public function get jid() : String
      {
         return getNode().attributes.jid;
      }
      
      public function set jid(param1:String) : void
      {
         getNode().attributes.jid = param1;
      }
      
      public function get username() : String
      {
         return this.getField("jid");
      }
      
      public function set username(param1:String) : void
      {
         this.setField("jid",param1);
      }
      
      public function get nick() : String
      {
         return this.getField("nick");
      }
      
      public function set nick(param1:String) : void
      {
         this.setField("nick",param1);
      }
      
      public function get first() : String
      {
         return this.getField("first");
      }
      
      public function set first(param1:String) : void
      {
         this.setField("first",param1);
      }
      
      public function get last() : String
      {
         return this.getField("last");
      }
      
      public function set last(param1:String) : void
      {
         this.setField("last",param1);
      }
      
      public function get email() : String
      {
         return this.getField("email");
      }
      
      public function set email(param1:String) : void
      {
         this.setField("email",param1);
      }
      
      public function get name() : String
      {
         return this.getField("name");
      }
      
      public function set name(param1:String) : void
      {
         this.setField("name",param1);
      }
   }
}

