package org.igniterealtime.xiff.data.muc
{
   import flash.xml.XMLNode;
   import org.igniterealtime.xiff.data.XMLStanza;
   
   public class MUCStatus
   {
      
      private var node:XMLNode;
      
      private var parent:XMLStanza;
      
      public function MUCStatus(param1:XMLNode, param2:XMLStanza)
      {
         super();
         this.node = Boolean(param1) ? param1 : new XMLNode(1,"status");
         this.parent = param2;
      }
      
      public function get code() : Number
      {
         return this.node.attributes.code;
      }
      
      public function set code(param1:Number) : void
      {
         this.node.attributes.code = param1.toString();
      }
      
      public function get message() : String
      {
         return this.node.firstChild.nodeValue;
      }
      
      public function set message(param1:String) : void
      {
         this.node = this.parent.replaceTextNode(this.parent.getNode(),this.node,"status",param1);
      }
   }
}

