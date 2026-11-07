package com.riotgames.pvpnet.celebration.views
{
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.button.LabelButtonX;
   import blix.context.IContext;
   import blix.layout.LayoutContainerView;
   import blix.layout.algorithms.VerticalLayout;
   import blix.layout.vo.HorizontalAlign;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import blix.view.behaviors.ScalingTransformBehavior;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.domain.celebration.SimpleDialogMessage;
   import com.riotgames.pvpnet.celebration.ClientModuleCelebration;
   import com.riotgames.rust.components.text.InputTextFieldProxy;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextFieldAutoSize;
   import flash.ui.Keyboard;
   import mx.resources.ResourceManager;
   
   public class FirstTimeLeaverDialogue extends SpriteProxy implements ICelebrationDialog
   {
      
      private var _dialogDismissed:Signal = new Signal();
      
      private var _model:SimpleDialogMessage;
      
      private var _layoutContainer:LayoutContainerView;
      
      private var _titleText:TextFieldProxy;
      
      private var _horizontalRule:SpriteProxy;
      
      private var _bodyText:TextFieldProxy;
      
      private var _bodyText2:TextFieldProxy;
      
      private var _spacer:SpriteProxy;
      
      private var _inputTextField:InputTextFieldProxy;
      
      private var _dismissButton:LabelButtonX;
      
      private var _background:SpriteProxy;
      
      private var _agreementString:String = RiotResourceLoader.getResourceString(ClientModuleCelebration.CELEBRATION_RESOURCE_ID,"first_time_leaver_agreement","");
      
      public function FirstTimeLeaverDialogue(param1:IContext, param2:Sprite = null)
      {
         super(param1,param2);
         setLinkage("FirstTimeLeaverDialogue");
      }
      
      override protected function createChildren() : void
      {
         this._layoutContainer = new LayoutContainerView(this);
         this._layoutContainer.getLayoutInvalidated().add(invalidateLayout);
         setTimelineChildByName("container",this._layoutContainer);
         var _loc1_:VerticalLayout = new VerticalLayout();
         _loc1_.setGap(5);
         _loc1_.setHorizontalAlign(HorizontalAlign.CENTER);
         this._layoutContainer.setLayoutAlgorithm(_loc1_);
         this._titleText = new TextFieldProxy(this);
         this._titleText.setText(RiotResourceLoader.getResourceString(ClientModuleCelebration.CELEBRATION_RESOURCE_ID,"first_time_leaver_warning_title","**Title"));
         this._titleText.setAutoSize(TextFieldAutoSize.LEFT);
         this._layoutContainer.setTimelineChildByName("titleText",this._titleText);
         this._layoutContainer.addElement(this._titleText);
         this._horizontalRule = new SpriteProxy(this);
         this._layoutContainer.setTimelineChildByName("spacer",this._horizontalRule);
         this._layoutContainer.addElement(this._horizontalRule);
         this._bodyText = new TextFieldProxy(this);
         this._bodyText.setHtmlText("<font face=\'ApplicationFont2\'>" + RiotResourceLoader.getResourceString(ClientModuleCelebration.CELEBRATION_RESOURCE_ID,"first_time_leaver_warning_body1","",[this._agreementString]) + "</font>");
         this._bodyText.setAutoSize(TextFieldAutoSize.LEFT);
         this._bodyText.setMouseWheelEnabled(false);
         this._layoutContainer.setTimelineChildByName("bodyText",this._bodyText);
         this._layoutContainer.addElement(this._bodyText);
         this._bodyText2 = new TextFieldProxy(this);
         this._bodyText2.setAutoSize(TextFieldAutoSize.CENTER);
         this._bodyText2.setMouseEnabled(false);
         this._bodyText2.setText(RiotResourceLoader.getResourceString(ClientModuleCelebration.CELEBRATION_RESOURCE_ID,"first_time_leaver_warning_body2","",[this._agreementString]));
         this._layoutContainer.setTimelineChildByName("bodyText2",this._bodyText2);
         this._layoutContainer.addElement(this._bodyText2);
         this._spacer = new SpriteProxy(this);
         this._layoutContainer.setTimelineChildByName("sizer",this._spacer);
         this._layoutContainer.addElement(this._spacer);
         this._inputTextField = new InputTextFieldProxy(this);
         this._inputTextField.setText("");
         this._inputTextField.setHintTextColor(3355443);
         this._inputTextField.setHintText(RiotResourceLoader.getResourceString(ClientModuleCelebration.CELEBRATION_RESOURCE_ID,"first_time_leaver_input_hint","",[this._agreementString]));
         this._inputTextField.addEventListener(Event.CHANGE,this.handleInputTextChanged);
         this._inputTextField.addEventListener(KeyboardEvent.KEY_DOWN,this.handleTextInputKeyDown);
         this._layoutContainer.setTimelineChildByName("inputText",this._inputTextField);
         this._layoutContainer.addElement(this._inputTextField);
         this._dismissButton = new LabelButtonX(this);
         this._dismissButton.setText(ResourceManager.getInstance().getString("resources","common_button_ok"));
         this._dismissButton.addEventListener(MouseEvent.CLICK,this.handleDismissButtonClicked);
         this._dismissButton.setEnabled(false);
         this._layoutContainer.setTimelineChildByName("dismissButton",this._dismissButton);
         this._layoutContainer.addElement(this._dismissButton);
         this._background = new SpriteProxy(this);
         this._background.setTransformBehavior(new ScalingTransformBehavior());
         setTimelineChildByName("background",this._background);
         super.createChildren();
      }
      
      private function handleTextInputKeyDown(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.ENTER)
         {
            if(this._dismissButton.getEnabled())
            {
               this.dismissDialogue();
            }
         }
      }
      
      private function handleInputTextChanged(param1:Event) : void
      {
         this.updateButtonState();
      }
      
      private function updateButtonState() : void
      {
         if(this._inputTextField.getText().toLowerCase() == this._agreementString.toLowerCase())
         {
            this._dismissButton.setEnabled(true);
         }
         else
         {
            this._dismissButton.setEnabled(false);
         }
      }
      
      private function handleDismissButtonClicked(param1:MouseEvent) : void
      {
         this.dismissDialogue();
      }
      
      private function dismissDialogue() : void
      {
         this._dialogDismissed.dispatch(this,this._model);
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         var _loc3_:Point = this._layoutContainer.setExplicitSize(NaN,NaN);
         this._background.setExplicitSize(NaN,_loc3_.y + 18);
         return super.updateLayout(param1,param2);
      }
      
      public function getDialogDismissed() : ISignal
      {
         return this._dialogDismissed;
      }
      
      public function setModel(param1:SimpleDialogMessage, param2:String) : void
      {
         this._model = param1;
      }
   }
}

