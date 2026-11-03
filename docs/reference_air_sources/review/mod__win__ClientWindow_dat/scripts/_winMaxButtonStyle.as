package
{
   import mx.core.IFlexModuleFactory;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleManager;
   
   public class _winMaxButtonStyle
   {
      
      private static var _embed_css_win_max_up_png_1577606538:Class = _winMaxButtonStyle__embed_css_win_max_up_png_1577606538;
      
      private static var _embed_css_win_max_over_png_1475583088:Class = _winMaxButtonStyle__embed_css_win_max_over_png_1475583088;
      
      private static var _embed_css_win_max_down_png_1728521092:Class = _winMaxButtonStyle__embed_css_win_max_down_png_1728521092;
      
      private static var _embed_css_win_max_dis_png_2082232904:Class = _winMaxButtonStyle__embed_css_win_max_dis_png_2082232904;
      
      public function _winMaxButtonStyle()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         var fbs:IFlexModuleFactory = param1;
         var style:CSSStyleDeclaration = StyleManager.getStyleDeclaration(".winMaxButton");
         if(!style)
         {
            style = new CSSStyleDeclaration();
            StyleManager.setStyleDeclaration(".winMaxButton",style,false);
         }
         if(style.defaultFactory == null)
         {
            style.defaultFactory = function():void
            {
               this.upSkin = _embed_css_win_max_up_png_1577606538;
               this.downSkin = _embed_css_win_max_down_png_1728521092;
               this.overSkin = _embed_css_win_max_over_png_1475583088;
               this.disabledSkin = _embed_css_win_max_dis_png_2082232904;
            };
         }
      }
   }
}

