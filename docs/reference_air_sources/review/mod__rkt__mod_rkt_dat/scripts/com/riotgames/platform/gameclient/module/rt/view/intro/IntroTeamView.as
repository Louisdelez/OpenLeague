package com.riotgames.platform.gameclient.module.rt.view.intro
{
   import blix.assets.proxy.DisplayObjectProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.intro.IntroScreen;
   import blix.components.button.ButtonX;
   import blix.signals.Signal;
   import com.riotgames.platform.gameclient.module.rt.RTFacade;
   import com.riotgames.platform.gameclient.module.rt.resource.RTContext;
   import com.riotgames.platform.gameclient.module.rt.resource.RTResource;
   import com.riotgames.platform.gameclient.module.rt.view.common.IActivatableView;
   import com.riotgames.rust.components.FlashFlexComponent;
   import com.riotgames.rust.components.text.AutoSizeTextFieldProxy;
   import org.puremvc.as3.multicore.interfaces.IMediator;
   
   public class IntroTeamView extends FlashFlexComponent implements IActivatableView
   {
      
      public var createButton:ButtonX;
      
      private var _mediator:IMediator;
      
      public var notLevel30Text:AutoSizeTextFieldProxy;
      
      public var linkClickSignal:Signal = new Signal();
      
      public function IntroTeamView(param1:RTContext)
      {
         super(param1,"rt.IntroScreen");
         var _loc2_:IntroScreen = new IntroScreen();
         this.createButton = param1.viewUtil.wireButton(this.view,_loc2_.createButton,null);
         this.notLevel30Text = new AutoSizeTextFieldProxy(this.view);
         this.view.setTimelineChildByName("notLevel30Text",this.notLevel30Text);
         this.notLevel30Text.setText(RTResource.getString("rt_notLevel30"));
      }
      
      override protected function createView() : DisplayObjectProxy
      {
         return new SpriteProxy(_context);
      }
      
      public function get view() : SpriteProxy
      {
         return _view as SpriteProxy;
      }
      
      public function activate() : void
      {
         if(!this._mediator)
         {
            this._mediator = new IntroTeamMediator(IntroTeamMediator.NAME,this);
         }
         RTFacade.instance.registerMediator(this._mediator);
      }
      
      public function deactivate() : void
      {
         RTFacade.instance.removeMediator(IntroTeamMediator.NAME);
      }
   }
}

