package com.riotgames.platform.common.xmpp.data.invite
{
   import com.riotgames.platform.gameclient.domain.invite.InviteParticipant;
   import flash.xml.XMLNode;
   import org.igniterealtime.xiff.core.UnescapedJID;
   import org.igniterealtime.xiff.data.XMLStanza;
   
   public class InviteParticipantXML extends XMLStanza
   {
      
      public static var ELEMENT:String = "entry";
      
      public static var ATTRIBUTE_TYPE:String = "roster";
      
      public static var ENTRY_FIELD_JID:String = "jid";
      
      public static var ENTRY_FIELD_SUMMONER_ID:String = "summonerId";
      
      public static var ENTRY_FIELD_NAME:String = "name";
      
      public static var ENTRY_FIELD_STATUS:String = "status";
      
      public static var ENTRY_FIELD_ICON_ID:String = "profileIconId";
      
      public function InviteParticipantXML(param1:XMLNode = null)
      {
         super();
         if(param1 != null)
         {
            super.setNode(param1);
         }
         else
         {
            super.getNode().nodeName = ELEMENT;
            super.getNode().attributes.type = ATTRIBUTE_TYPE;
         }
      }
      
      public function serialize(param1:XMLNode, param2:InviteParticipant) : void
      {
         addTextNode(getNode(),ENTRY_FIELD_JID,param2.jid.bareJID);
         addTextNode(getNode(),ENTRY_FIELD_SUMMONER_ID,param2.summonerId.toString());
         addTextNode(getNode(),ENTRY_FIELD_NAME,param2.name);
         addTextNode(getNode(),ENTRY_FIELD_STATUS,param2.status);
         addTextNode(getNode(),ENTRY_FIELD_ICON_ID,param2.profileIconId.toString());
         param1.appendChild(getNode());
      }
      
      public function deserialize() : InviteParticipant
      {
         var _loc2_:XMLNode = null;
         var _loc1_:InviteParticipant = new InviteParticipant();
         for each(_loc2_ in getNode().childNodes)
         {
            switch(_loc2_.nodeName)
            {
               case ENTRY_FIELD_JID:
                  _loc1_.jid = new UnescapedJID(_loc2_.firstChild.nodeValue);
                  break;
               case ENTRY_FIELD_SUMMONER_ID:
                  _loc1_.summonerId = parseFloat(_loc2_.firstChild.nodeValue);
               case ENTRY_FIELD_NAME:
                  _loc1_.name = _loc2_.firstChild.nodeValue;
                  break;
               case ENTRY_FIELD_STATUS:
                  _loc1_.status = _loc2_.firstChild.nodeValue;
                  break;
               case ENTRY_FIELD_ICON_ID:
                  _loc1_.profileIconId = parseInt(_loc2_.firstChild.nodeValue);
            }
         }
         return _loc1_;
      }
   }
}

