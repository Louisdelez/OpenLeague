package com.riotgames.platform.gameclient.kudos.iron
{
   import blix.assets.IAssetsManager;
   import com.riotgames.platform.gameclient.domain.PlayerParticipantStatsSummary;
   import com.riotgames.platform.gameclient.kudos.IKudosButton;
   import com.riotgames.platform.gameclient.kudos.KudosFactoryDisabled;
   import flash.display.DisplayObject;
   import mx.core.UIComponent;
   
   public class IronKudosFactoryDisabled extends KudosFactoryDisabled
   {
      
      public function IronKudosFactoryDisabled()
      {
         super();
      }
      
      override public function getKudosButton(param1:UIComponent, param2:int, param3:Boolean, param4:Number, param5:PlayerParticipantStatsSummary, param6:Number, param7:DisplayObject, param8:Function = null, param9:Function = null) : IKudosButton
      {
         var _loc10_:IAssetsManager = this.context.getDependency(IAssetsManager);
         return new IronKudosButtonDisabled(_loc10_);
      }
   }
}

