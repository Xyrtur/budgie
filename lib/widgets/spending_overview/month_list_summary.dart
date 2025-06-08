/** CurrentMonthWidget
 * 	return Container 
 * 				margin, vertical
 * 				boxShadow
 * 				child:
 * 					Column children [
 * 								Row spaceBetween children []
 * 								SingleBarGraph
 * 								Progress
 * 								
 * 
 * 					]
 * 	
 * 
 * NormalMonthWidget 
 * 	return SizedBox Column
 * 		children: [
 * 				Text(yearMonthRangeList[index]),
 * 				Row  spaceBetween
 * 						children: [
 * 
 *  						SingleBarGraph(SpendingTrackerBloc.getMonthData(yearMonthRangeList[index])),
 * 							Text(SpendingTrackerBloc.getMonthTotal(yearMonthRangeList[index]))
 * 								
 * 						]
 * 		]
 * 
 * SingleBarGraph (isCurrentMonth)
 *  if month is after currentMonth, just show budget limits
 * if SettingsBloc.showTotals, show totals under the graph parts
 * 
 */
