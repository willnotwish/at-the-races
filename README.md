# at-the-races
The purpose of this repo is to investigate database race conditions.

I have an issue in production on a commercial project where I am ending up with empty parent records in the database when concurrent attempts are made to update child records.

The system uses Rails 4.2.10 and mySQL 5.5. I know these are old, but I cannot upgrade.

I am changing the names of the classes to remove some commercial context.

Suppose I have the following Active Rcord (AR) models.
- A `Month` - a particular month in time (_e.g._, Jan 2024, March 2000), comprising a full name (_e.g._ January 2024) and a short code (_e.g._, jan24).
- A `Counter` containing a symbolic name (a `code`), an integer `value`, and belonging to a `month`.
- A `CounterUpdate` containing an updated value for a given counter, comprising the short code of the month, the symbolic name of the counter and its updated value.

The idea is to track monthly usage according to that month's counter.

Periodically (anything from milliseconds to days), new counter updates "arrive" in the form of API requests, CSV uploads or via a temporary database table.

An update is processed by updating the value of the appropriate counter. Counters are created on demand.

The issue I sometimes encounter in production is where two updates come in close together, and two counters -- rather than one -- are created.
