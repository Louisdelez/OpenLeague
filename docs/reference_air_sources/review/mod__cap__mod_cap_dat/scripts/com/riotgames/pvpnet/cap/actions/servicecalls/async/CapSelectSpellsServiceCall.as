package com.riotgames.pvpnet.cap.actions.servicecalls.async
{
   import com.riotgames.platform.common.services.lcdsproxy.ILcdsProxyServiceMessenger;
   import com.riotgames.platform.common.services.lcdsproxy.servicecalls.AsyncLcdsProxyServiceCall;
   import com.riotgames.platform.common.utils.encode.IEncode;
   import com.riotgames.platform.gameclient.domain.Spell;
   import com.riotgames.platform.gameclient.notification.ClientNotificationProxyServiceName;
   
   public class CapSelectSpellsServiceCall extends AsyncLcdsProxyServiceCall
   {
      
      private static const METHOD_NAME:String = "pickSpellsV2";
      
      private var _spell1:Spell;
      
      private var _spell2:Spell;
      
      public function CapSelectSpellsServiceCall(param1:Spell, param2:Spell, param3:ILcdsProxyServiceMessenger, param4:IEncode)
      {
         super(param3,ClientNotificationProxyServiceName.CAP,METHOD_NAME,param4);
         this._spell1 = param1;
         this._spell2 = param2;
      }
      
      public function get spell1() : Spell
      {
         return this._spell1;
      }
      
      override public function getRequestPayload(param1:Object = null) : Object
      {
         param1 = super.getRequestPayload(param1);
         if(this._spell1 != null)
         {
            param1.spell1Id = this._spell1.spellId;
         }
         if(this._spell2 != null)
         {
            param1.spell2Id = this._spell2.spellId;
         }
         return param1;
      }
      
      public function get spell2() : Spell
      {
         return this._spell2;
      }
   }
}

