package org.igniterealtime.xiff.data
{
   import flash.xml.XMLNode;
   import org.igniterealtime.xiff.core.EscapedJID;
   import org.igniterealtime.xiff.data.muc.MUCUserExtension;
   import org.igniterealtime.xiff.data.xhtml.XHTMLExtension;
   
   public class Message extends XMPPStanza implements ISerializable
   {
      
      public static var NORMAL_TYPE:String = "normal";
      
      public static var CHAT_TYPE:String = "chat";
      
      public static var GROUPCHAT_TYPE:String = "groupchat";
      
      public static var HEADLINE_TYPE:String = "headline";
      
      public static var ERROR_TYPE:String = "error";
      
      private static var isMessageStaticCalled:Boolean = MessageStaticConstructor();
      
      private static var staticConstructorDependency:Array = [XMPPStanza,XHTMLExtension,ExtensionClassRegistry];
      
      private var myBodyNode:XMLNode;
      
      private var mySubjectNode:XMLNode;
      
      private var myThreadNode:XMLNode;
      
      private var myTimeStampNode:XMLNode;
      
      public function Message(param1:EscapedJID = null, param2:String = null, param3:String = null, param4:String = null, param5:String = null, param6:String = null)
      {
         var _loc7_:String = exists(param2) ? param2 : generateID("m_");
         super(param1,null,param5,_loc7_,"message");
         this.body = param3;
         this.htmlBody = param4;
         this.subject = param6;
      }
      
      public static function MessageStaticConstructor() : Boolean
      {
         XHTMLExtension.enable();
         return true;
      }
      
      override public function serialize(param1:XMLNode) : Boolean
      {
         return super.serialize(param1);
      }
      
      override public function deserialize(param1:XMLNode) : Boolean
      {
         var _loc3_:Array = null;
         var _loc4_:String = null;
         var _loc5_:MUCUserExtension = null;
         var _loc2_:Boolean = super.deserialize(param1);
         if(_loc2_)
         {
            _loc3_ = param1.childNodes;
            for(_loc4_ in _loc3_)
            {
               switch(_loc3_[_loc4_].nodeName)
               {
                  case "error":
                     break;
                  case "body":
                     this.myBodyNode = _loc3_[_loc4_];
                     break;
                  case "subject":
                     this.mySubjectNode = _loc3_[_loc4_];
                     break;
                  case "thread":
                     this.myThreadNode = _loc3_[_loc4_];
                     break;
                  case "x":
                     if(_loc3_[_loc4_].attributes.xmlns == "jabber:x:delay")
                     {
                        this.myTimeStampNode = _loc3_[_loc4_];
                     }
                     if(_loc3_[_loc4_].attributes.xmlns == MUCUserExtension.NS)
                     {
                        _loc5_ = new MUCUserExtension(getNode());
                        _loc5_.deserialize(_loc3_[_loc4_]);
                        addExtension(_loc5_);
                     }
               }
            }
         }
         return _loc2_;
      }
      
      public function get body() : String
      {
         var value:String;
         if(!exists(this.myBodyNode))
         {
            return null;
         }
         value = "";
         try
         {
            if(Boolean(this.myBodyNode) && Boolean(this.myBodyNode.firstChild))
            {
               value = this.myBodyNode.firstChild.nodeValue;
            }
         }
         catch(error:Error)
         {
         }
         return value;
      }
      
      public function set body(param1:String) : void
      {
         this.myBodyNode = replaceTextNode(getNode(),this.myBodyNode,"body",param1);
      }
      
      public function get htmlBody() : String
      {
         var ext:XHTMLExtension = null;
         try
         {
            ext = getAllExtensionsByNS(XHTMLExtension.NS)[0];
            return ext.body;
         }
         catch(e:Error)
         {
         }
         return null;
      }
      
      public function set htmlBody(param1:String) : void
      {
         var _loc2_:XHTMLExtension = null;
         removeAllExtensions(XHTMLExtension.NS);
         if(exists(param1) && param1.length > 0)
         {
            _loc2_ = new XHTMLExtension(getNode());
            _loc2_.body = param1;
            addExtension(_loc2_);
         }
      }
      
      public function get subject() : String
      {
         if(this.mySubjectNode == null)
         {
            return null;
         }
         return this.mySubjectNode.firstChild.nodeValue;
      }
      
      public function set subject(param1:String) : void
      {
         this.mySubjectNode = replaceTextNode(getNode(),this.mySubjectNode,"subject",param1);
      }
      
      public function get thread() : String
      {
         if(this.myThreadNode == null)
         {
            return null;
         }
         return this.myThreadNode.firstChild.nodeValue;
      }
      
      public function set thread(param1:String) : void
      {
         this.myThreadNode = replaceTextNode(getNode(),this.myThreadNode,"thread",param1);
      }
      
      public function set time(param1:Date) : void
      {
      }
      
      public function get time() : Date
      {
         if(this.myTimeStampNode == null)
         {
            return null;
         }
         var _loc1_:String = this.myTimeStampNode.attributes.stamp;
         var _loc2_:Date = new Date();
         _loc2_.setUTCFullYear(_loc1_.slice(0,4));
         _loc2_.setUTCMonth(Number(_loc1_.slice(4,6)) - 1);
         _loc2_.setUTCDate(_loc1_.slice(6,8));
         _loc2_.setUTCHours(_loc1_.slice(9,11));
         _loc2_.setUTCMinutes(_loc1_.slice(12,14));
         _loc2_.setUTCSeconds(_loc1_.slice(15,17));
         return _loc2_;
      }
   }
}

