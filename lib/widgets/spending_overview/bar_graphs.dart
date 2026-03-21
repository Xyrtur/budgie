// Detailed Bar Graph

// For current month / monthly spending page

/*
Information needed

limits of each genre
amount spent in each genre

UI

Animate to slide open on creation or rebuild of this widget

have certain length for whole bar

totalLength

totalLengthMoney = for each genre, += (amountSpent > limit ? amountSpent : limit)

perDollarLength = totalLength / totalLengthMoney


Row(for each genre, 

Container(width: (amountSpent > limit ? limit : amountSpent )* perDollarLength)
Container(width: (amountSpent == limit ? 0 : abs(amountSpent - limit)) * perDollarLength, redOutline and filled if amountSpent - limit > 0, colored outline and empty otherwise)


Row (for each genre, colored dot with amountSpent after)



*/


// Simple Bar Graph

// For all other months in spending overview pages


/*
Information needed

amount spent in each genre

Need perDollarLength depending on other months from spendingOverviewPage

UI

Animate to slide open on creation or rebuild of this widget

Row (for each genre,

Container(width: amountSpent * perDollarLength)



\
*/


// FutureBarGraph

// need limits in each genre

// Grayed out version of graph with only limits
