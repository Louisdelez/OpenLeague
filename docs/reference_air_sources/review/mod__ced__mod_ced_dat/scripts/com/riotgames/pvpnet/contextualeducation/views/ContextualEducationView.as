package com.riotgames.pvpnet.contextualeducation.views
{
   import blix.signals.Signal;
   import com.riotgames.platform.common.AppConfig;
   import com.riotgames.platform.module.RiotModuleInfo;
   import com.riotgames.pvpnet.contextualeducation.model.ContextualEducationTipModel;
   import com.riotgames.pvpnet.system.config.UserPreferencesManager;
   import com.riotgames.rust.components.text.HTMLTextFieldProxy;
   import com.riotgames.rust.module.RiotModuleView;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.net.URLRequest;
   import flash.text.StyleSheet;
   import flash.text.TextFieldAutoSize;
   
   public class ContextualEducationView extends RiotModuleView
   {
      
      private var _assetsUrlRequest:URLRequest;
      
      private var animationStepsRequired:uint = 0;
      
      private var _txtTipHead:HTMLTextFieldProxy;
      
      private var _txtTipBody:HTMLTextFieldProxy;
      
      private var _styleSheet:StyleSheet;
      
      private var _hideCompleted:Signal = new Signal();
      
      private var _moduleInfo:RiotModuleInfo;
      
      private var _tipModel:ContextualEducationTipModel;
      
      public function ContextualEducationView(param1:RiotModuleInfo, param2:ContextualEducationTipModel)
      {
         this._tipModel = param2;
         super(null,new MovieClip());
         this._moduleInfo = param1;
         loadAssets(getThemeAssetUrl(this._moduleInfo.getPath(),"ContextualEducationAssets.swf"));
         setLinkage("Main");
         setCurrentState("intro");
      }
      
      private function checkAnimationStepsRequired() : void
      {
         --this.animationStepsRequired;
         if(this.animationStepsRequired === 0)
         {
            this.playAnimation();
         }
      }
      
      private function playAnimation() : void
      {
         setTransitionsEnabled(UserPreferencesManager.globalPrefs.enableAnimations);
         AppConfig.instance.minimizedChanged.remove(this.playAnimation);
         getIsOnStageChanged().remove(this.playAnimation);
         setCurrentState("intro");
         setCurrentState("default");
      }
      
      private function updateTipView(param1:Event = null) : void
      {
         this._txtTipHead.setHtmlText(this._tipModel.header);
         this._txtTipBody.setHtmlText(this._tipModel.body);
         this.animationStepsRequired = 0;
         if(AppConfig.instance.minimized)
         {
            ++this.animationStepsRequired;
            AppConfig.instance.minimizedChanged.add(this.checkAnimationStepsRequired);
         }
         if(!getIsOnStage())
         {
            ++this.animationStepsRequired;
            getIsOnStageChanged().add(this.checkAnimationStepsRequired);
         }
         if(this.animationStepsRequired === 0)
         {
            this.playAnimation();
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._styleSheet = new StyleSheet();
         this._styleSheet.setStyle("h1",{
            "fontWeight":"bold",
            "fontSize":"16pt"
         });
         this._styleSheet.setStyle("a:link",{
            "color":"#46ABF6",
            "textDecoration":"none"
         });
         this._styleSheet.setStyle("a:hover",{"textDecoration":"underline"});
         this._txtTipHead = new HTMLTextFieldProxy(this,null,HTMLTextFieldProxy.APPLICATION_FONT_2);
         this._txtTipHead.setStyleSheet(this._styleSheet);
         this._txtTipHead.setAutoSize(TextFieldAutoSize.LEFT);
         setTimelineChildByName("txtTipHead",this._txtTipHead);
         this._txtTipBody = new HTMLTextFieldProxy(this,null,HTMLTextFieldProxy.APPLICATION_FONT_2);
         this._txtTipBody.setStyleSheet(this._styleSheet);
         this._txtTipBody.setAutoSize(TextFieldAutoSize.LEFT);
         setTimelineChildByName("txtTipBody",this._txtTipBody);
         this._tipModel.addEventListener(Event.CHANGE,this.updateTipView,false,0,true);
         this.updateTipView();
      }
      
      override public function setVisible(param1:Boolean) : void
      {
         super.setVisible(param1);
      }
   }
}

