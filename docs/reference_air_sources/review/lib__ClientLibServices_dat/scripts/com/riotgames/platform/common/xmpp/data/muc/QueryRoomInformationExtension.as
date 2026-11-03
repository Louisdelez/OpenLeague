package com.riotgames.platform.common.xmpp.data.muc
{
   import flash.xml.XMLNode;
   import org.igniterealtime.xiff.data.disco.InfoDiscoExtension;
   import org.igniterealtime.xiff.data.forms.FormExtension;
   import org.igniterealtime.xiff.data.forms.FormField;
   
   public class QueryRoomInformationExtension extends InfoDiscoExtension
   {
      
      public static const NS:String = "http://jabber.org/protocol/disco#info";
      
      public static const ROOM_OCCUPANTS:String = "muc#roominfo_occupants";
      
      public function QueryRoomInformationExtension()
      {
         super(null);
      }
      
      override public function getNS() : String
      {
         return QueryRoomInformationExtension.NS;
      }
      
      public function getOccupantCount() : int
      {
         var _loc1_:int = 0;
         var _loc2_:FormExtension = this.getExtension(FormExtension.ELEMENT) as FormExtension;
         if(_loc2_ == null)
         {
            return _loc1_;
         }
         var _loc3_:FormField = _loc2_.getFormField(QueryRoomInformationExtension.ROOM_OCCUPANTS);
         if(_loc3_ == null)
         {
            return _loc1_;
         }
         return parseInt(_loc3_.value);
      }
      
      override public function deserialize(param1:XMLNode) : Boolean
      {
         var _loc2_:XMLNode = null;
         var _loc3_:FormExtension = null;
         if(!super.deserialize(param1))
         {
            return false;
         }
         for each(_loc2_ in getNode().childNodes)
         {
            if(_loc2_.nodeName == FormExtension.ELEMENT && _loc2_.namespaceURI == FormExtension.NS)
            {
               _loc3_ = new FormExtension(getNode());
               _loc3_.deserialize(_loc2_);
               this.addExtension(_loc3_);
            }
         }
         return true;
      }
   }
}

