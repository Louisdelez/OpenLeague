package com.riotgames.pvpnet.itembrowser.utils
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
         this.itemDescriptionStylesheet.setStyle("restricted",{
            "color":"#EA4F00",
            "display":"inline"
         });
         this.itemDescriptionStylesheet.setStyle("possiblyRestricted",{
            "color":"#EABB00",
            "display":"inline"
         });
         this.itemDescriptionStylesheet.setStyle("notRestricted",{
            "color":"#FFFFFF",
            "display":"inline"
         });
         this.itemDescriptionStylesheet.setStyle("stats",{
            "color":"#99FF99",
            "display":"inline"
         });
         this.itemDescriptionStylesheet.setStyle("passiveText",{
            "color":"#FFFFFF",
            "display":"inline"
         });
         this.itemDescriptionStylesheet.setStyle("passive",{
            "color":"#FFDD22",
            "display":"inline"
         });
         this.itemDescriptionStylesheet.setStyle("unique",{
            "color":"#FFDD22",
            "display":"inline"
         });
         this.itemDescriptionStylesheet.setStyle("active",{
            "color":"#FFDD22",
            "display":"inline"
         });
         this.itemDescriptionStylesheet.setStyle("aura",{
            "color":"#FFDD22",
            "display":"inline"
         });
         this.itemDescriptionStylesheet.setStyle("consumable",{
            "color":"#FF8811",
            "display":"inline"
         });
         this.itemDescriptionStylesheet.setStyle("cooldown",{
            "fontWeight":"bold",
            "color":"#FFFFFF",
            "display":"inline"
         });
         this.itemDescriptionStylesheet.setStyle("rules",{
            "fontStyle":"italic",
            "fontSize":"15pt",
            "display":"inline"
         });
         this.itemDescriptionStylesheet.setStyle("flavor",{
            "fontStyle":"italic",
            "fontSize":"15pt",
            "display":"inline"
         });
      }
      
      public static function getInstance() : ItemStyles
      {
         return instance;
      }
   }
}

