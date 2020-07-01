import React from 'react'
import { Link } from 'react-router-dom'
import context from 'lib/context'

const Layout = ({ children }) => {
  console.log('rerender')
  console.log(context.state)

  const loggedIn = !!context.state.user

  return (
    <>
      <header>
        TT Scheduler

        <div className="links">
          {loggedIn && <Link to="/admin">Admin</Link>}
          {loggedIn && <Link to="/">Book</Link>}
          {loggedIn && `logged in as ${context.state.user.name}`}
          {loggedIn && <button onClick={context.unauthenticate}>log out</button>}
        </div>
      </header>

      <main>
        {children}
      </main>
    </>
  )
}

export default Layout