package org.igniterealtime.xiff.data.auth
{
   import flash.xml.XMLNode;
   import org.igniterealtime.xiff.data.Extension;
   import org.igniterealtime.xiff.data.ExtensionClassRegistry;
   import org.igniterealtime.xiff.data.IExtension;
   import org.igniterealtime.xiff.data.ISerializable;
   import org.igniterealtime.xiff.data.XMLStanza;
   
   public class AuthExtension extends Extension implements IExtension, ISerializable
   {
      
      public static var NS:String = "jabber:iq:auth";
      
      public static var ELEMENT:String = "query";
      
      private var myUsernameNode:XMLNode;
      
      private var myPasswordNode:XMLNode;
      
      private var myDigestNode:XMLNode;
      
      private var myResourceNode:XMLNode;
      
      public function AuthExtension(param1:XMLNode = null)
      {
         super(param1);
      }
      
      public static function enable() : void
      {
         ExtensionClassRegistry.register(AuthExtension);
      }
      
      public static function computeDigest(param1:String, param2:String) : String
      {
         return SHA1.calcSHA1(param1 + param2).toLowerCase();
      }
      
      public function getNS() : String
      {
         return AuthExtension.NS;
      }
      
      public function getElementName() : String
      {
         return AuthExtension.ELEMENT;
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
         var _loc2_:Array = param1.childNodes;
         for(_loc3_ in _loc2_)
         {
            switch(_loc2_[_loc3_].nodeName)
            {
               case "username":
                  this.myUsernameNode = _loc2_[_loc3_];
                  break;
               case "password":
                  this.myPasswordNode = _loc2_[_loc3_];
                  break;
               case "digest":
                  this.myDigestNode = _loc2_[_loc3_];
                  break;
               case "resource":
                  this.myResourceNode = _loc2_[_loc3_];
            }
         }
         return true;
      }
      
      public function isDigest() : Boolean
      {
         return exists(this.myDigestNode);
      }
      
      public function isPassword() : Boolean
      {
         return exists(this.myPasswordNode);
      }
      
      public function get username() : String
      {
         return this.myUsernameNode.firstChild.nodeValue;
      }
      
      public function set username(param1:String) : void
      {
         this.myUsernameNode = replaceTextNode(getNode(),this.myUsernameNode,"username",param1);
      }
      
      public function get password() : String
      {
         return this.myPasswordNode.firstChild.nodeValue;
      }
      
      public function set password(param1:String) : void
      {
         this.myDigestNode = this.myDigestNode == null ? XMLStanza.XMLFactory.createElement("") : this.myDigestNode;
         this.myDigestNode.removeNode();
         this.myDigestNode = null;
         this.myPasswordNode = replaceTextNode(getNode(),this.myPasswordNode,"password",param1);
      }
      
      public function get digest() : String
      {
         return this.myDigestNode.firstChild.nodeValue;
      }
      
      public function set digest(param1:String) : void
      {
         this.myPasswordNode.removeNode();
         this.myPasswordNode = null;
         this.myDigestNode = replaceTextNode(getNode(),this.myDigestNode,"digest",param1);
      }
      
      public function get resource() : String
      {
         return this.myResourceNode.firstChild.nodeValue;
      }
      
      public function set resource(param1:String) : void
      {
         this.myResourceNode = replaceTextNode(getNode(),this.myResourceNode,"resource",param1);
      }
   }
}

