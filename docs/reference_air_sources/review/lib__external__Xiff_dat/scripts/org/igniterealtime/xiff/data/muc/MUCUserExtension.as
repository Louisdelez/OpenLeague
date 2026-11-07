package org.igniterealtime.xiff.data.muc
{
   import flash.xml.XMLNode;
   import org.igniterealtime.xiff.core.EscapedJID;
   import org.igniterealtime.xiff.data.IExtension;
   
   public class MUCUserExtension extends MUCBaseExtension implements IExtension
   {
      
      public static var NS:String = "http://jabber.org/protocol/muc#user";
      
      public static var ELEMENT:String = "x";
      
      public static var DECLINE_TYPE:String = "decline";
      
      public static var DESTROY_TYPE:String = "destroy";
      
      public static var INVITE_TYPE:String = "invite";
      
      public static var OTHER_TYPE:String = "other";
      
      private var myActionNode:XMLNode;
      
      private var myPasswordNode:XMLNode;
      
      private var myStatuses:Array = [];
      
      public function MUCUserExtension(param1:XMLNode = null)
      {
         super(param1);
      }
      
      public function getNS() : String
      {
         return MUCUserExtension.NS;
      }
      
      public function getElementName() : String
      {
         return MUCUserExtension.ELEMENT;
      }
      
      override public function deserialize(param1:XMLNode) : Boolean
      {
         var _loc2_:XMLNode = null;
         super.deserialize(param1);
         for each(_loc2_ in param1.childNodes)
         {
            switch(_loc2_.nodeName)
            {
               case DECLINE_TYPE:
                  this.myActionNode = _loc2_;
                  break;
               case DESTROY_TYPE:
                  this.myActionNode = _loc2_;
                  break;
               case INVITE_TYPE:
                  this.myActionNode = _loc2_;
                  break;
               case "status":
                  this.myStatuses.push(new MUCStatus(_loc2_,this));
                  break;
               case "password":
                  this.myPasswordNode = _loc2_;
            }
         }
         return true;
      }
      
      public function get type() : String
      {
         if(this.myActionNode == null)
         {
            return null;
         }
         return this.myActionNode.nodeName == null ? OTHER_TYPE : this.myActionNode.nodeName;
      }
      
      public function get to() : EscapedJID
      {
         return new EscapedJID(this.myActionNode.attributes.to);
      }
      
      public function get from() : EscapedJID
      {
         return new EscapedJID(this.myActionNode.attributes.from);
      }
      
      public function get jid() : EscapedJID
      {
         return new EscapedJID(this.myActionNode.attributes.jid);
      }
      
      public function get reason() : String
      {
         if(this.myActionNode.firstChild != null)
         {
            if(this.myActionNode.firstChild.firstChild != null)
            {
               return this.myActionNode.firstChild.firstChild.nodeValue;
            }
         }
         return null;
      }
      
      public function invite(param1:EscapedJID, param2:EscapedJID, param3:String) : void
      {
         this.updateActionNode(INVITE_TYPE,{
            "to":param1.toString(),
            "from":(Boolean(param2) ? param2.toString() : null)
         },param3);
      }
      
      public function destroy(param1:EscapedJID, param2:String) : void
      {
         this.updateActionNode(DESTROY_TYPE,{"jid":param1.toString()},param2);
      }
      
      public function decline(param1:EscapedJID, param2:EscapedJID, param3:String) : void
      {
         this.updateActionNode(DECLINE_TYPE,{
            "to":param1.toString(),
            "from":(Boolean(param2) ? param2.toString() : null)
         },param3);
      }
      
      public function get password() : String
      {
         if(this.myPasswordNode == null)
         {
            return null;
         }
         return this.myPasswordNode.firstChild.nodeValue;
      }
      
      public function set password(param1:String) : void
      {
         this.myPasswordNode = replaceTextNode(getNode(),this.myPasswordNode,"password",param1);
      }
      
      public function get statuses() : Array
      {
         return this.myStatuses;
      }
      
      public function set statuses(param1:Array) : void
      {
         this.myStatuses = param1;
      }
      
      public function hasStatusCode(param1:Number) : Boolean
      {
         var _loc2_:MUCStatus = null;
         for each(_loc2_ in this.statuses)
         {
            if(_loc2_.code == param1)
            {
               return true;
            }
         }
         return false;
      }
      
      private function updateActionNode(param1:String, param2:Object, param3:String) : void
      {
         var _loc4_:String = null;
         if(this.myActionNode != null)
         {
            this.myActionNode.removeNode();
         }
         this.myActionNode = XMLFactory.createElement(param1);
         for(_loc4_ in param2)
         {
            if(exists(param2[_loc4_]))
            {
               this.myActionNode.attributes[_loc4_] = param2[_loc4_];
            }
         }
         getNode().appendChild(this.myActionNode);
         if(param3.length > 0)
         {
            replaceTextNode(this.myActionNode,undefined,"reason",param3);
         }
      }
   }
}

