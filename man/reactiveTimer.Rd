\name{reactiveTimer}
\alias{reactiveTimer}
\title{Timer}
\usage{
  reactiveTimer(intervalMs = 1000, session)
}
\arguments{
  \item{intervalMs}{How often to fire, in milliseconds}

  \item{session}{A session object. This is needed to cancel
  any scheduled invalidations after a user has ended the
  session. If \code{NULL}, then this invalidation will not
  be tied to any session, and so it will still occur.}
}
\value{
  A no-parameter function that can be called from a
  reactive context, in order to cause that context to be
  invalidated the next time the timer interval elapses.
  Calling the returned function also happens to yield the
  current time (as in \code{\link{Sys.time}}).
}
\description{
  Creates a reactive timer with the given interval. A
  reactive timer is like a reactive value, except reactive
  values are triggered when they are set, while reactive
  timers are triggered simply by the passage of time.
}
\details{
  \link[=reactive]{Reactive expressions} and observers that
  want to be invalidated by the timer need to call the
  timer function that \code{reactiveTimer} returns, even if
  the current time value is not actually needed.

  See \code{\link{invalidateLater}} as a safer and simpler
  alternative.
}
\examples{
\dontrun{
shinyServer(function(input, output, session) {

  # Anything that calls autoInvalidate will automatically invalidate
  # every 2 seconds.
  autoInvalidate <- reactiveTimer(2000, session)

  observe({
    # Invalidate and re-execute this reactive expression every time the
    # timer fires.
    autoInvalidate()

    # Do something each time this is invalidated.
    # The isolate() makes this observer _not_ get invalidated and re-executed
    # when input$n changes.
    print(paste("The value of input$n is", isolate(input$n)))
  })

  # Generate a new histogram each time the timer fires, but not when
  # input$n changes.
  output$plot <- renderPlot({
    autoInvalidate()
    hist(isolate(input$n))
  })
})
}
}
\seealso{
  \code{\link{invalidateLater}}
}

