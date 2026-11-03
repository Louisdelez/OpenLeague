package com.riotgames.pvpnet.window.chrome
{
   import blix.context.IContext;
   import com.riotgames.platform.provider.ProviderModuleInfo;
   import com.riotgames.pvpnet.system.product.IProductProvider;
   import com.riotgames.rust.module.RiotModuleView;
   
   public class ProductSwitcherButton extends RiotModuleView
   {
      
      protected var _moduleInfo:ProviderModuleInfo;
      
      protected var _product:IProductProvider;
      
      protected var _isLoggedIn:Boolean;
      
      protected var _isPatched:Boolean;
      
      public function ProductSwitcherButton(param1:IContext, param2:ProviderModuleInfo, param3:IProductProvider)
      {
         this._moduleInfo = param2;
         this._product = param3;
         super(param1);
         this.initializeProduct();
         setMouseEnabled(true);
         setButtonMode(true);
      }
      
      private function initializeProduct() : void
      {
         this._product.getIsLoggedInChanged().add(this.updateLoggedInStatus);
         this._product.getIsPatchedChanged().add(this.updatePatchedStatus);
         this._isLoggedIn = this._product.getIsLoggedIn();
         this._isPatched = this._product.getIsPatched();
         this.updateDisplay();
      }
      
      private function updateLoggedInStatus() : void
      {
         this._isLoggedIn = this._product.getIsLoggedIn();
         this.updateDisplay();
      }
      
      private function updatePatchedStatus() : void
      {
         this._isPatched = this._product.getIsPatched();
         this.updateDisplay();
      }
      
      protected function updateDisplay() : void
      {
      }
   }
}

