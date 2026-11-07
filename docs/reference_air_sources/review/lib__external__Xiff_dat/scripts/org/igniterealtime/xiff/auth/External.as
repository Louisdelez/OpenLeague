package org.igniterealtime.xiff.auth
{
   import flash.xml.XMLNode;
   import mx.utils.Base64Encoder;
   import org.igniterealtime.xiff.core.UnescapedJID;
   import org.igniterealtime.xiff.core.XMPPConnection;
   
   public class External extends SASLAuth
   {
      
      public function External(param1:XMPPConnection)
      {
         super();
         var _loc2_:UnescapedJID = param1.jid;
         var _loc3_:String = _loc2_.node;
         var _loc4_:Base64Encoder = new Base64Encoder();
         _loc4_.insertNewLines = false;
         _loc4_.encode(_loc3_);
         _loc3_ = _loc4_.flush();
         var _loc5_:Object = {
            "mechanism":"EXTERNAL",
            "xmlns":"urn:ietf:params:xml:ns:xmpp-sasl"
         };
         req = new XMLNode(1,"auth");
         req.appendChild(new XMLNode(3,_loc3_));
         req.attributes = _loc5_;
         stage = 0;
      }
      
      override public function handleResponse(param1:int, param2:XMLNode) : Object
      {
         var _loc3_:Boolean = param2.nodeName == "success";
         return {
            "authComplete":true,
            "authSuccess":_loc3_,
            "authStage":param1++
         };
      }
   }
}

