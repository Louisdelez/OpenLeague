package com.riotgames.platform.gameclient.module.rt.view.create
{
   import blix.assets.proxy.DisplayObjectProxy;
   import com.riotgames.platform.gameclient.module.rt.RTFacade;
   import com.riotgames.platform.gameclient.module.rt.resource.RTContext;
   import com.riotgames.pvpnet.component.DeprecatedAudioButton;
   import com.riotgames.rust.components.FlashFlexComponent;
   
   public class CreateButton extends FlashFlexComponent
   {
      
      public function CreateButton(param1:RTContext)
      {
         super(param1,"rt.CreateTeamButton");
         RTFacade.instance.registerMediator(new CreateButtonMediator(CreateButtonMediator.NAME,this));
      }
      
      override protected function createView() : DisplayObjectProxy
      {
         return new DeprecatedAudioButton(_context);
      }
      
      public function get view() : DeprecatedAudioButton
      {
         return _view as DeprecatedAudioButton;
      }
   }
}

