package com.riotgames.platform.gameclient.domain.inventory
{
   import com.riotgames.platform.gameclient.domain.IChampionFilter;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import flash.globalization.Collator;
   import flash.globalization.CollatorMode;
   
   public class CollatorChampionFilter extends ChampionFilter implements IChampionFilter
   {
      
      private var collator:Collator = new Collator(ClientConfig.instance.locale,CollatorMode.SORTING);
      
      public function CollatorChampionFilter(param1:Array)
      {
         super(param1);
      }
      
      override protected function compareChampionDisplayNames(param1:String, param2:String) : int
      {
         return this.collator.compare(param1,param2);
      }
   }
}

