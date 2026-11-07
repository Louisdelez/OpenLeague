package com.hurlant.crypto.tests
{
   import com.hurlant.math.BigInteger;
   import com.hurlant.util.Hex;
   
   public class BigIntegerTest extends TestCase
   {
      
      public function BigIntegerTest(param1:ITestHarness)
      {
         super(param1,"BigInteger Tests");
         runTest(this.testAdd,"BigInteger Addition");
         param1.endTestCase();
      }
      
      public function testAdd() : void
      {
         var _loc1_:BigInteger = BigInteger.nbv(25);
         var _loc2_:BigInteger = BigInteger.nbv(1002);
         var _loc3_:BigInteger = _loc1_.add(_loc2_);
         var _loc4_:int = _loc3_.valueOf();
         assert("25+1002 = " + _loc4_,25 + 1002 == _loc4_);
         var _loc5_:BigInteger = new BigInteger(Hex.toArray("e564d8b801a61f47"));
         var _loc6_:BigInteger = new BigInteger(Hex.toArray("99246db2a3507fa"));
         _loc6_ = _loc6_.add(_loc5_);
         assert("xp==eef71f932bdb2741",_loc6_.toString(16) == "eef71f932bdb2741");
      }
   }
}

