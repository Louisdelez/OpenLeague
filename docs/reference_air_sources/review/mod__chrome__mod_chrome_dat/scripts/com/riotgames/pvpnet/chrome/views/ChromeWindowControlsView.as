package com.riotgames.pvpnet.chrome.views
{
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.button.ButtonX;
   import blix.components.tooltip.assignToolTip;
   import blix.context.IContext;
   import com.riotgames.platform.gameclient.application.Version;
   import com.riotgames.pvpnet.chrome.ChromeController;
   import com.riotgames.pvpnet.system.cursor.NativeCursors;
   import flash.events.MouseEvent;
   import flash.text.TextFieldAutoSize;
   import mx.resources.ResourceManager;
   
   public class ChromeWindowControlsView extends SpriteProxy
   {
      
      private var _closeButton:ButtonX;
      
      private var _minimizeButton:ButtonX;
      
      private var _versionText:TextFieldProxy;
      
      private var _topBar:SpriteProxy;
      
      private var _topLeftResizeTarget:ResizeHandleView;
      
      private var _bottomRightResizeTarget:ResizeHandleView;
      
      private var _bottomLeftResizeTarget:ResizeHandleView;
      
      private var _leftResizeTarget:ResizeHandleView;
      
      private var _rightResizeTarget:ResizeHandleView;
      
      public function ChromeWindowControlsView(param1:IContext)
      {
         super(param1);
         setLinkage("WindowControls");
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._versionText = new TextFieldProxy(this);
         setTimelineChildByName("versionText",this._versionText);
         this._versionText.setAutoSize(TextFieldAutoSize.LEFT);
         this._versionText.setText("League of Legends " + Version.CURRENT_VERSION);
         this._closeButton = new ButtonX(this);
         setTimelineChildByName("closeButton",this._closeButton);
         assignToolTip(this._closeButton,ResourceManager.getInstance().getString("resources","applicationClose_tooltip"));
         this._closeButton.addEventListener(MouseEvent.CLICK,this.handleCloseButtonClicked);
         this._minimizeButton = new ButtonX(this);
         setTimelineChildByName("minimizeButton",this._minimizeButton);
         assignToolTip(this._minimizeButton,ResourceManager.getInstance().getString("resources","applicationMinimize_tooltip"));
         this._minimizeButton.addEventListener(MouseEvent.CLICK,this.handleMinimizeButtonClicked);
         this._topBar = new SpriteProxy(this);
         this._topBar.addEventListener(MouseEvent.MOUSE_DOWN,this.onTopBarDown);
         this._topBar.addEventListener(MouseEvent.DOUBLE_CLICK,this.onTopBarDoubleClick);
         this._topBar.setDoubleClickEnabled(true);
         setTimelineChildByName("topBar",this._topBar);
         this._topLeftResizeTarget = new ResizeHandleView(this,NativeCursors.RESIZE_NW,"TL");
         setTimelineChildByName("topLeftResizeTarget",this._topLeftResizeTarget);
         this._bottomRightResizeTarget = new ResizeHandleView(this,NativeCursors.RESIZE_NW,"BR");
         setTimelineChildByName("bottomRightResizeTarget",this._bottomRightResizeTarget);
         this._bottomLeftResizeTarget = new ResizeHandleView(this,NativeCursors.RESIZE_NE,"BL");
         setTimelineChildByName("bottomLeftResizeTarget",this._bottomLeftResizeTarget);
         this._leftResizeTarget = new ResizeHandleView(this,NativeCursors.RESIZE_W,"L");
         setTimelineChildByName("leftResizeTarget",this._leftResizeTarget);
         this._rightResizeTarget = new ResizeHandleView(this,NativeCursors.RESIZE_W,"R");
         setTimelineChildByName("rightResizeTarget",this._rightResizeTarget);
      }
      
      private function get controller() : ChromeController
      {
         return getDependency(ChromeController);
      }
      
      private function handleCloseButtonClicked(param1:MouseEvent) : void
      {
         this.controller.close();
      }
      
      private function handleMinimizeButtonClicked(param1:MouseEvent) : void
      {
         this.controller.minimize();
      }
      
      private function onTopBarDown(param1:MouseEvent) : void
      {
         this.controller.drag();
      }
      
      private function onTopBarDoubleClick(param1:MouseEvent) : void
      {
         this.controller.setToDefaultSize();
      }
   }
}

