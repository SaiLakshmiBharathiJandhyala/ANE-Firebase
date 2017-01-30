/**
 *        __       __               __ 
 *   ____/ /_ ____/ /______ _ ___  / /_
 *  / __  / / ___/ __/ ___/ / __ `/ __/
 * / /_/ / (__  ) / / /  / / /_/ / / 
 * \__,_/_/____/_/ /_/  /_/\__, /_/ 
 *                           / / 
 *                           \/ 
 * http://distriqt.com
 *
 * @author 		"Michael Archbold (ma&#64;distriqt.com)"
 * @copyright	http://distriqt.com/copyright/license.txt
 */
package com.distriqt.test.firebase
{
	import com.distriqt.extension.firebase.database.MutableData;
	import com.distriqt.extension.firebase.database.transactions.TransactionHandler;
	import com.distriqt.extension.firebase.database.transactions.TransactionResult;
	
	/**	
	 *
	 */
	public class CountTransactionHandler implements TransactionHandler
	{
		
		public function doTransaction( mutableData:MutableData ):TransactionResult
		{
			var data:Object = mutableData.getValue();
			if (data == null)
			{
				// Set an initial value
				mutableData.setValue( 1 );
				return TransactionResult.success(mutableData);
			}
			mutableData.setValue( mutableData.getValue() + 1 );
			return TransactionResult.success(mutableData);
		}
		
	}
}