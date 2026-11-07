package com.riotgames.platform.common.provider
{
   import blix.assets.proxy.DisplayObjectProxy;
   import blix.context.IContext;
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.platform.gameclient.domain.GameItem;
   import com.riotgames.platform.gameclient.domain.Spell;
   import com.riotgames.platform.gameclient.views.icons.IChampionIconRenderer;
   import com.riotgames.platform.gameclient.views.icons.IItemIconRenderer;
   import com.riotgames.platform.gameclient.views.icons.ISpellIconRenderer;
   import com.riotgames.platform.gameclient.views.icons.ISummonerIconRenderer;
   
   public interface IIconProvider
   {
      
      function getSpellIconRendererById(param1:int, param2:IContext) : ISpellIconRenderer;
      
      function getItemIconRendererByGameItem(param1:GameItem, param2:IContext) : IItemIconRenderer;
      
      function getSpellIconRendererBySpell(param1:Spell, param2:IContext) : ISpellIconRenderer;
      
      function getChampionTooltipByChampion(param1:Champion, param2:String = "") : DisplayObjectProxy;
      
      function getEmptyItemIconRenderer(param1:IContext) : IItemIconRenderer;
      
      function getSpellTooltipBySpell(param1:Spell) : DisplayObjectProxy;
      
      function getEmptySummonerIconRenderer(param1:IContext) : ISummonerIconRenderer;
      
      function getChampionIconRendererById(param1:Number, param2:IContext) : IChampionIconRenderer;
      
      function getSummonerTooltipById(param1:int, param2:String, param3:String, param4:String) : DisplayObjectProxy;
      
      function getSummonerIconRendererById(param1:int, param2:IContext) : ISummonerIconRenderer;
      
      function getEmptySpellIconRenderer(param1:IContext) : ISpellIconRenderer;
      
      function getItemTooltipByGameItem(param1:GameItem) : DisplayObjectProxy;
      
      function getItemIconRendererById(param1:int, param2:IContext) : IItemIconRenderer;
      
      function getChampionIconRendererBySkinName(param1:String, param2:IContext) : IChampionIconRenderer;
      
      function getEmptyChampionIconRenderer(param1:IContext) : IChampionIconRenderer;
   }
}

