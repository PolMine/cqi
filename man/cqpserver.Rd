% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cqpserver.R
\name{cqpserver}
\alias{cqpserver}
\alias{startServer}
\title{start CQP server}
\usage{
startServer(registryDir = Sys.getenv("CORPUS_REGISTRY"),
  initFile = system.file("init", "cqpserver.init", package = "cqi"),
  debugMode = TRUE, exec = TRUE)
}
\arguments{
\item{registryDir}{path to the registry directory}

\item{initFile}{path to the init file required by cqpserver}

\item{debugMode}{logical, whether to run debug mode}
}
\description{
The function will start the CQP server by way of a system call 
to cqpserver.
}

