package org.igniterealtime.xiff.data.register
{
   import flash.xml.XMLNode;
   import org.igniterealtime.xiff.data.Extension;
   import org.igniterealtime.xiff.data.ExtensionClassRegistry;
   import org.igniterealtime.xiff.data.IExtension;
   import org.igniterealtime.xiff.data.ISerializable;
   
   public class RegisterExtension extends Extension implements IExtension, ISerializable
   {
      
      public static var NS:String = "jabber:iq:register";
      
      public static var ELEMENT:String = "query";
      
      private static var staticDepends:Class = ExtensionClassRegistry;
      
      private var myFields:Object;
      
      private var myKeyNode:XMLNode;
      
      private var myInstructionsNode:XMLNode;
      
      private var myRemoveNode:XMLNode;
      
      public function RegisterExtension(param1:XMLNode = null)
      {
         super(param1);
         this.myFields = new Object();
      }
      
      public static function enable() : void
      {
         ExtensionClassRegistry.register(RegisterExtension);
      }
      
      public function getNS() : String
      {
         return RegisterExtension.NS;
      }
      
      public function getElementName() : String
      {
         return RegisterExtension.ELEMENT;
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
         setNode(param1);
         var _loc2_:Array = getNode().childNodes;
         for(_loc3_ in _loc2_)
         {
            switch(_loc2_[_loc3_].nodeName)
            {
               case "key":
                  this.myKeyNode = _loc2_[_loc3_];
                  break;
               case "instructions":
                  this.myInstructionsNode = _loc2_[_loc3_];
                  break;
               case "remove":
                  this.myRemoveNode = _loc2_[_loc3_];
                  break;
               default:
                  this.myFields[_loc2_[_loc3_].nodeName] = _loc2_[_loc3_];
            }
         }
         return true;
      }
      
      public function get unregister() : Boolean
      {
         return exists(this.myRemoveNode);
      }
      
      public function set unregister(param1:Boolean) : void
      {
         this.myRemoveNode = replaceTextNode(getNode(),this.myRemoveNode,"remove","");
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
      
      public function get key() : String
      {
         return this.myKeyNode.firstChild.nodeValue;
      }
      
      public function set key(param1:String) : void
      {
         this.myKeyNode = replaceTextNode(getNode(),this.myKeyNode,"key",param1);
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
      
      public function get username() : String
      {
         return this.getField("username");
      }
      
      public function set username(param1:String) : void
      {
         this.setField("username",param1);
      }
      
      public function get nick() : String
      {
         return this.getField("nick");
      }
      
      public function set nick(param1:String) : void
      {
         this.setField("nick",param1);
      }
      
      public function get password() : String
      {
         return this.getField("password");
      }
      
      public function set password(param1:String) : void
      {
         this.setField("password",param1);
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
      
      public function get address() : String
      {
         return this.getField("address");
      }
      
      public function set address(param1:String) : void
      {
         this.setField("address",param1);
      }
      
      public function get city() : String
      {
         return this.getField("city");
      }
      
      public function set city(param1:String) : void
      {
         this.setField("city",param1);
      }
      
      public function get state() : String
      {
         return this.getField("state");
      }
      
      public function set state(param1:String) : void
      {
         this.setField("state",param1);
      }
      
      public function get zip() : String
      {
         return this.getField("zip");
      }
      
      public function set zip(param1:String) : void
      {
         this.setField("zip",param1);
      }
      
      public function get phone() : String
      {
         return this.getField("phone");
      }
      
      public function set phone(param1:String) : void
      {
         this.setField("phone",param1);
      }
      
      public function get url() : String
      {
         return this.getField("url");
      }
      
      public function set url(param1:String) : void
      {
         this.setField("url",param1);
      }
      
      public function get date() : String
      {
         return this.getField("date");
      }
      
      public function set date(param1:String) : void
      {
         this.setField("date",param1);
      }
      
      public function get misc() : String
      {
         return this.getField("misc");
      }
      
      public function set misc(param1:String) : void
      {
         this.setField("misc",param1);
      }
      
      public function get text() : String
      {
         return this.getField("text");
      }
      
      public function set text(param1:String) : void
      {
         this.setField("text",param1);
      }
   }
}

