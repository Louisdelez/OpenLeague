package com.riotgames.pvpnet.model
{
   import com.riotgames.platform.gameclient.domain.Spell;
   
   public class SpellSelection
   {
      
      private var _available:Boolean = false;
      
      private var _spell:Spell;
      
      private var _selected:Boolean = false;
      
      private var _selectedIndex:int = -1;
      
      public function SpellSelection(param1:Spell, param2:Boolean, param3:Boolean = false)
      {
         super();
         this.spell = param1;
         this.available = param2;
         this.selected = param3;
      }
      
      public function get minLevel() : int
      {
         if(Boolean(this.spell))
         {
            return this.spell.minLevel;
         }
         return int.MAX_VALUE;
      }
      
      public function get spell() : Spell
      {
         return this._spell;
      }
      
      public function get available() : Boolean
      {
         return this._available;
      }
      
      public function set selectedIndex(param1:int) : void
      {
         if(this._selectedIndex == param1)
         {
            return;
         }
         this._selectedIndex = param1;
      }
      
      public function set spell(param1:Spell) : void
      {
         if(this._spell == param1)
         {
            return;
         }
         this._spell = param1;
      }
      
      public function set selected(param1:Boolean) : void
      {
         if(this._selected == param1)
         {
            return;
         }
         this._selected = param1;
      }
      
      public function set available(param1:Boolean) : void
      {
         if(this._available == param1)
         {
            return;
         }
         this._available = param1;
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function get selectedIndex() : int
      {
         return this._selectedIndex;
      }
   }
}

