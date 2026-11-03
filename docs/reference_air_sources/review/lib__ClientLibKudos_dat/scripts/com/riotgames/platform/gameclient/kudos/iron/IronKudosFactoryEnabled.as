package com.riotgames.platform.gameclient.kudos.iron
{
   import blix.assets.IAssetsManager;
   import com.riotgames.platform.common.resource.FlatFileResourceLoader;
   import com.riotgames.platform.gameclient.domain.PlayerParticipantStatsSummary;
   import com.riotgames.platform.gameclient.kudos.IKudosButton;
   import com.riotgames.platform.gameclient.kudos.KudosFactoryEnabled;
   import com.riotgames.rust.context.RustContext;
   import flash.display.DisplayObject;
   import mx.core.UIComponent;
   
   public class IronKudosFactoryEnabled extends KudosFactoryEnabled
   {
      
      public function IronKudosFactoryEnabled(param1:RustContext = null, param2:FlatFileResourceLoader = null)
      {
         super(param1,param2);
      }
      
      override public function getKudosButton(param1:UIComponent, param2:int, param3:Boolean, param4:Number, param5:PlayerParticipantStatsSummary, param6:Number, param7:DisplayObject, param8:Function = null, param9:Function = null) : IKudosButton
      {
         var _loc10_:IAssetsManager = this.context.getDependency(IAssetsManager);
         return new IronKudosButtonEnabled(_loc10_,param3,param4,param5,param6,param7,param8,param9);
      }
   }
}

