package com.riotgames.platform.gameclient.controllers.game.views
{
   import com.riotgames.platform.common.utils.app.ApplicationUtil;
   import com.riotgames.platform.gameclient.controllers.game.controllers.AdvancedToolTipManager;
   import com.riotgames.platform.gameclient.controllers.game.event.RunePageSelectEvent;
   import com.riotgames.platform.gameclient.domain.SpellBookDTO;
   import com.riotgames.platform.gameclient.domain.SpellBookPageDTO;
   import flash.accessibility.*;
   import flash.data.*;
   import flash.debugger.*;
   import flash.desktop.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.external.*;
   import flash.filesystem.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.html.*;
   import flash.html.script.*;
   import flash.media.*;
   import flash.net.*;
   import flash.printing.*;
   import flash.profiler.*;
   import flash.system.*;
   import flash.text.*;
   import flash.ui.*;
   import flash.utils.*;
   import flash.xml.*;
   import mx.binding.*;
   import mx.controls.ComboBox;
   import mx.events.DropdownEvent;
   import mx.events.ListEvent;
   import mx.styles.*;
   
   public class RunePageSelecter extends ComboBox
   {
      
      private var _spellBook:SpellBookDTO;
      
      private var currentTooltipData:Object = null;
      
      public function RunePageSelecter()
      {
         super();
         this.labelField = "displayName";
         this.styleName = "runeSelectionComboBox";
         this.rowCount = 10;
         this.height = 24;
         this.addEventListener("change",this.___RunePageSelecter_ComboBox1_change);
         this.addEventListener("close",this.___RunePageSelecter_ComboBox1_close);
         this.addEventListener("itemRollOver",this.___RunePageSelecter_ComboBox1_itemRollOver);
         this.addEventListener("rollOut",this.___RunePageSelecter_ComboBox1_rollOut);
         this.addEventListener("removedFromStage",this.___RunePageSelecter_ComboBox1_removedFromStage);
      }
      
      private function showStatsTooltip(param1:ListEvent) : void
      {
         var _loc2_:RuneStatsTooltip = new RuneStatsTooltip();
         _loc2_.data = param1.itemRenderer.data;
         this.currentTooltipData = _loc2_.data;
         var _loc3_:Point = this.contentToGlobal(new Point(this.width + 25,(-100 + _loc2_.yOffset) * ApplicationUtil.application.scaleY));
         AdvancedToolTipManager.createCustomToolTip(_loc3_.x,_loc3_.y,_loc2_);
      }
      
      public function set spellBook(param1:SpellBookDTO) : void
      {
         if(this._spellBook == param1)
         {
            return;
         }
         this._spellBook = param1;
         this.setSpellBook();
      }
      
      private function onRunePageSelected(param1:ListEvent) : void
      {
         var _loc2_:SpellBookPageDTO = this.selectedItem as SpellBookPageDTO;
         this.hideStatsTooltip();
         if(_loc2_)
         {
            this.dispatchEvent(new RunePageSelectEvent(RunePageSelectEvent.PAGE_SELECTED,_loc2_,true));
         }
      }
      
      private function hideStatsTooltip() : void
      {
         if(AdvancedToolTipManager.toolTipOpen)
         {
            AdvancedToolTipManager.destroyCurrentToolTip();
         }
      }
      
      public function ___RunePageSelecter_ComboBox1_change(param1:ListEvent) : void
      {
         this.onRunePageSelected(param1);
      }
      
      public function ___RunePageSelecter_ComboBox1_removedFromStage(param1:Event) : void
      {
         this.hideStatsTooltip();
      }
      
      private function setDefaultPage() : void
      {
         if(!this.spellBook)
         {
            return;
         }
         var _loc1_:Boolean = true;
         var _loc2_:int = 0;
         while(_loc2_ < this.spellBook.bookPages.length)
         {
            if(this.spellBook.bookPages[_loc2_].current)
            {
               this.selectedIndex = _loc2_;
               _loc1_ = false;
               break;
            }
            _loc2_++;
         }
         if(_loc1_)
         {
            this.onRunePageSelected(null);
         }
      }
      
      private function setSpellBook() : void
      {
         if(this.spellBook)
         {
            this.dataProvider = this.spellBook.bookPages;
            if(this.dropdown)
            {
               this.dropdown.dataProvider = this.dataProvider;
            }
         }
         else
         {
            this.dataProvider = null;
         }
         this.setDefaultPage();
      }
      
      override public function initialize() : void
      {
         super.initialize();
      }
      
      public function get spellBook() : SpellBookDTO
      {
         return this._spellBook;
      }
      
      public function ___RunePageSelecter_ComboBox1_rollOut(param1:MouseEvent) : void
      {
         this.hideStatsTooltip();
      }
      
      public function ___RunePageSelecter_ComboBox1_itemRollOver(param1:ListEvent) : void
      {
         this.showStatsTooltip(param1);
      }
      
      public function ___RunePageSelecter_ComboBox1_close(param1:DropdownEvent) : void
      {
         this.hideStatsTooltip();
      }
   }
}

