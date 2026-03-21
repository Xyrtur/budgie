/*
Actions

Add monthly expense


Information Needed

soFarSpent query
monthlyBudget query 
^^^ need limits of genres as well as total budget(includes fixed but dont need fixed number)
incomeTxns query
expenseTxns query
^^^  sort into lists based on the genre 
^^^ blocs state will give out the genres and their colors, as well as a dictionary, key: genre, value: list of expenses


UI
BlocBuilder at top for when an expense gets added for that month, update whole page

Column

Row(Text(currentMonth), Text(soFarSpentQuery + " of " + monthlyBudgetQuery))

DetailedBarGraph

Container(Text(Income), list incomes using incomeTxnsQuery)

Text(Expenses)

>> Container for each genre using genresPresent Query 

Container(color: genreColor, Text(genreName), list of expenses)




*/