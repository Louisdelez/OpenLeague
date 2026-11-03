package com.riotgames.platform.gameclient.controllers.game.event
{
   import com.riotgames.platform.gameclient.domain.Spell;
   import flash.events.Event;
   
   public class SpellSelectEvent extends Event
   {
      
      public static const SPELLS_SELECTED:String = "spellsSelected";
      
      public static const OPEN_SPELL_SELECT:String = "openSpellSelect";
      
      public static const CHANGE_SPELL_1_REQUESTED:String = "changeSpell1Requested";
      
      public static const CHANGE_SPELL_2_REQUESTED:String = "changeSpell2Requested";
      
      private var _spell1:Spell;
      
      private var _spell2:Spell;
      
      public function SpellSelectEvent(param1:String, param2:Spell, param3:Spell, param4:Boolean = false, param5:Boolean = false)
      {
         super(param1,param4,param5);
         this._spell1 = param2;
         this._spell2 = param3;
      }
      
      public function get spell1() : Spell
      {
         return this._spell1;
      }
      
      public function get spell2() : Spell
      {
         return this._spell2;
      }
      
      override public function clone() : Event
      {
         return new SpellSelectEvent(type,this.spell1,this.spell2,bubbles,cancelable);
      }
   }
}

