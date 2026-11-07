package org.igniterealtime.xiff.auth
{
   import flash.xml.XMLNode;
   import org.igniterealtime.xiff.core.XMPPConnection;
   
   public class Anonymous extends SASLAuth
   {
      
      public function Anonymous(param1:XMPPConnection)
      {
         super();
         var _loc2_:Object = {
            "mechanism":"ANONYMOUS",
            "xmlns":"urn:ietf:params:xml:ns:xmpp-sasl"
         };
         req = new XMLNode(1,"auth");
         req.attributes = _loc2_;
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

