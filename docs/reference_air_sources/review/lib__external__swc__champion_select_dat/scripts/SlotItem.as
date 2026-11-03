package
{
   import com.utils.Lib;
   import flash.display.MovieClip;
   import flash.events.Event;
   import mx.core.IUIComponent;
   import mx.flash.UIMovieClip;
   
   [Event(name="onTradeOptionSelectedEvent",type="TradeSelectEvent")]
   [Event(name="onTradeDeniedEvent",type="TradeSelectEvent")]
   [Event(name="onTradePendingEvent",type="TradeSelectEvent")]
   [Event(name="onTradeAcceptEvent",type="TradeSelectEvent")]
   [Event(name="onTradeRequestEvent",type="TradeSelectEvent")]
   [Embed(source="/_assets/assets.swf", symbol="symbol147")]
   public class SlotItem extends UIMovieClip
   {
      
      public var slotItemBg_mc:MovieClip;
      
      public var championImg:MyContainer;
      
      public var spellImg0:MyContainer;
      
      public var spellImg1:MyContainer;
      
      public function SlotItem()
      {
         super();
         this.addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
      }
      
      private function onAddedToStage(evt:Event) : void
      {
         this.init();
      }
      
      public function init() : void
      {
      }
      
      public function setComp(container:MyContainer, flexComp:IUIComponent) : IUIComponent
      {
         container.content = flexComp;
         return flexComp;
      }
      
      public function setSlotItem(champImg:IUIComponent, img0:IUIComponent, img1:IUIComponent) : SlotItem
      {
         this.setComp(this.championImg,champImg);
         this.setComp(this.spellImg0,img0);
         this.setComp(this.spellImg1,img1);
         return this;
      }
      
      override public function set currentState(value:String) : void
      {
         Lib.output("currentState:" + currentState);
         switch(value)
         {
            case ChampionSelect.CHAMPION_SELECT_STATE_INACTIVESELF:
               Lib.output("blue");
               this.championImg.overlay_mc.gotoAndStop("blue");
               this.spellImg0.overlay_mc.gotoAndStop("blue");
               this.spellImg1.overlay_mc.gotoAndStop("blue");
               break;
            case ChampionSelect.CHAMPION_SELECT_STATE_INACTIVEOTHER:
               Lib.output("grey");
               this.championImg.overlay_mc.gotoAndStop("grey");
               this.spellImg0.overlay_mc.gotoAndStop("grey");
               this.spellImg1.overlay_mc.gotoAndStop("grey");
               break;
            case ChampionSelect.CHAMPION_SELECT_STATE_ACTIVESELF:
               Lib.output("orange");
               this.championImg.overlay_mc.gotoAndStop("orange");
               this.spellImg0.overlay_mc.gotoAndStop("orange");
               this.spellImg1.overlay_mc.gotoAndStop("orange");
               break;
            case ChampionSelect.CHAMPION_SELECT_STATE_ACTIVEOTHER:
               Lib.output("grey");
               this.championImg.overlay_mc.gotoAndStop("grey");
               this.spellImg0.overlay_mc.gotoAndStop("grey");
               this.spellImg1.overlay_mc.gotoAndStop("grey");
         }
      }
   }
}

