package com.riotgames.pvpnet.cap.actions.servicecalls.async
{
   import com.riotgames.platform.common.services.lcdsproxy.ILcdsProxyServiceMessenger;
   import com.riotgames.platform.common.services.lcdsproxy.servicecalls.AsyncLcdsProxyServiceCall;
   import com.riotgames.platform.common.utils.encode.IEncode;
   import com.riotgames.platform.gameclient.domain.ChampionSkin;
   import com.riotgames.platform.gameclient.notification.ClientNotificationProxyServiceName;
   
   public class CapSelectSkinV2ServiceCall extends AsyncLcdsProxyServiceCall
   {
      
      public static const METHOD_NAME:String = "pickSkinV2";
      
      public var skinIsNew:Boolean;
      
      public var skin:ChampionSkin;
      
      public function CapSelectSkinV2ServiceCall(param1:ChampionSkin, param2:Boolean, param3:ILcdsProxyServiceMessenger, param4:IEncode)
      {
         this.skin = param1;
         this.skinIsNew = param2;
         super(param3,ClientNotificationProxyServiceName.CAP,METHOD_NAME,param4);
      }
      
      override public function getRequestPayload(param1:Object = null) : Object
      {
         param1 = super.getRequestPayload(param1);
         param1.skinId = this.skin.skinId;
         param1.isNewlyPurchasedSkin = this.skinIsNew;
         return param1;
      }
   }
}

