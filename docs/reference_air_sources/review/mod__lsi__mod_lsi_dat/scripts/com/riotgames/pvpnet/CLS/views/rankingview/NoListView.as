package com.riotgames.pvpnet.CLS.views.rankingview
{
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.context.IContext;
   import com.riotgames.pvpnet.CLS.localeHelper.ILocaleHelper;
   
   public class NoListView extends SpriteProxy
   {
      
      public static var NO_LIST_CHALLENGER:int = 1;
      
      public static var NO_LIST_DIVISION:int = 2;
      
      public static var NO_LIST_MASTER:int = 3;
      
      private var _emptyDivisionHeaderText:TextFieldProxy;
      
      private var _emptyDivisionSubText:TextFieldProxy;
      
      private var _noListChallengerTopLine:String;
      
      private var _noListChallengerBottomLine:String;
      
      private var _noListMasterTopLine:String;
      
      private var _noListMasterBottomLine:String;
      
      private var _noListDivisionTopLine:String;
      
      private var _noListDivisionBottomLine:String;
      
      public function NoListView(param1:IContext)
      {
         super(param1);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         var _loc1_:ILocaleHelper = getDependency(ILocaleHelper);
         this._emptyDivisionHeaderText = new TextFieldProxy(this);
         setTimelineChildByName("emptyDivisionHeaderText",this._emptyDivisionHeaderText);
         this._emptyDivisionHeaderText.setMouseEnabled(false);
         this._emptyDivisionHeaderText.setMouseWheelEnabled(false);
         this._emptyDivisionSubText = new TextFieldProxy(this);
         setTimelineChildByName("emptyDivisionSubText",this._emptyDivisionSubText);
         this._emptyDivisionSubText.setMouseEnabled(false);
         this._emptyDivisionSubText.setMouseWheelEnabled(false);
         this.setVisible(false);
         this._noListChallengerTopLine = _loc1_.localeLookup("pswNoListElementsChallenger1");
         this._noListChallengerBottomLine = _loc1_.localeLookup("pswNoListElementsChallenger2");
         this._noListDivisionTopLine = _loc1_.localeLookup("pswNoListElementsDivision1");
         this._noListDivisionBottomLine = _loc1_.localeLookup("pswNoListElementsDivision2");
         this._noListMasterTopLine = _loc1_.localeLookup("pswNoListElementsMaster1");
         this._noListMasterBottomLine = _loc1_.localeLookup("pswNoListElementsMaster2");
      }
      
      public function show(param1:int) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         switch(param1)
         {
            case NO_LIST_CHALLENGER:
               _loc2_ = this._noListChallengerTopLine;
               _loc3_ = this._noListChallengerBottomLine;
               break;
            case NO_LIST_MASTER:
               _loc2_ = this._noListMasterTopLine;
               _loc3_ = this._noListMasterBottomLine;
               break;
            case NO_LIST_DIVISION:
               _loc2_ = this._noListDivisionTopLine;
               _loc3_ = this._noListDivisionBottomLine;
         }
         this.setVisible(true);
         if(Boolean(this._emptyDivisionHeaderText) && Boolean(this._emptyDivisionSubText))
         {
            this._emptyDivisionHeaderText.setText(_loc2_);
            this._emptyDivisionSubText.setText(_loc3_);
         }
      }
      
      public function hide() : void
      {
         if(Boolean(this._emptyDivisionHeaderText) && Boolean(this._emptyDivisionSubText))
         {
            this._emptyDivisionHeaderText.setText("");
            this._emptyDivisionSubText.setText("");
         }
         this.setVisible(false);
      }
      
      public function setDefaultText() : void
      {
         if(Boolean(this._emptyDivisionHeaderText) && Boolean(this._emptyDivisionSubText))
         {
            this._emptyDivisionHeaderText.setText(this._noListChallengerTopLine);
            this._emptyDivisionSubText.setText(this._noListChallengerBottomLine);
         }
      }
   }
}

