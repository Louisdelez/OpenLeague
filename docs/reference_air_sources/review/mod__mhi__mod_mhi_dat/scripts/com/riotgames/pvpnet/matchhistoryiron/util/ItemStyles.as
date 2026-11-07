package com.riotgames.pvpnet.matchhistoryiron.util
{
   import flash.text.StyleSheet;
   
   public class ItemStyles
   {
      
      private static var instance:ItemStyles = new ItemStyles();
      
      public const itemDescriptionStylesheet:StyleSheet = new StyleSheet();
      
      public function ItemStyles()
      {
         super();
         if(instance)
         {
            return;
         }
         this.itemDescriptionStylesheet.setStyle("restricted",{"color":"#EA4F00"});
         this.itemDescriptionStylesheet.setStyle("possiblyRestricted",{"color":"#EABB00"});
         this.itemDescriptionStylesheet.setStyle("notRestricted",{"color":"#FFFFFF"});
         this.itemDescriptionStylesheet.setStyle("stats",{"color":"#99FF99"});
         this.itemDescriptionStylesheet.setStyle("passiveText",{"color":"#FFFFFF"});
         this.itemDescriptionStylesheet.setStyle("passive",{"color":"#FFDD22"});
         this.itemDescriptionStylesheet.setStyle("unique",{"color":"#FFDD22"});
         this.itemDescriptionStylesheet.setStyle("active",{"color":"#FFDD22"});
         this.itemDescriptionStylesheet.setStyle("aura",{"color":"#FFDD22"});
         this.itemDescriptionStylesheet.setStyle("consumable",{"color":"#FF8811"});
         this.itemDescriptionStylesheet.setStyle("cooldown",{
            "fontWeight":"bold",
            "color":"#FFFFFF"
         });
         this.itemDescriptionStylesheet.setStyle("rules",{
            "fontStyle":"italic",
            "fontSize":"15pt"
         });
         this.itemDescriptionStylesheet.setStyle("flavor",{
            "fontStyle":"italic",
            "fontSize":"15pt"
         });
      }
      
      public static function getInstance() : ItemStyles
      {
         return instance;
      }
   }
}

