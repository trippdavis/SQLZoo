# == Schema Information
#
# Table name: stops
#
#  id          :integer      not null, primary key
#  name        :string
#
# Table name: routes
#
#  num         :string       not null, primary key
#  company     :string       not null, primary key
#  pos         :integer      not null, primary key
#  stop_id     :integer

require_relative './sqlzoo.rb'

def num_stops
  # How many stops are in the database?
  execute(<<-SQL)
    SELECT
      COUNT(*)
    FROM
      stops
  SQL
end

def craiglockhart_id
  # Find the id value for the stop 'Craiglockhart'.
  execute(<<-SQL)
    SELECT
      id
    FROM
      stops
    WHERE
      name = 'Craiglockhart'
  SQL
end

def lrt_stops
  # Give the id and the name for the stops on the '4' 'LRT' service.
  execute(<<-SQL)
    SELECT
      s.*
    FROM
      stops s
    JOIN
      routes r ON s.id = r.stop_id
    WHERE
      r.num = '4' AND r.company = 'LRT'
  SQL
end

def connecting_routes
  execute(<<-SQL)
    SELECT
      company, num, COUNT(*)
    FROM
      routes
    WHERE
      stop_id = 149 OR stop_id = 53
    GROUP BY
      company, num
    HAVING
      COUNT(*) > 1
  SQL
end

def cl_to_lr
  execute(<<-SQL)
    SELECT
      a.company, a.num, a.stop_id, b.stop_id
    FROM
      routes a
    JOIN
      routes b ON (a.company = b.company AND a.num = b.num)
    WHERE
      a.stop_id = 53 AND b.stop_id = 149
  SQL
end

def cl_to_lr_by_name
  execute(<<-SQL)
    SELECT
      a.company, a.num, stopa.name, stopb.name
    FROM
      routes a
    JOIN
      routes b ON (a.company = b.company AND a.num = b.num)
    JOIN
      stops stopa ON (a.stop_id = stopa.id)
    JOIN
      stops stopb ON (b.stop_id = stopb.id)
    WHERE
      stopa.name = 'Craiglockhart' AND stopb.name = 'London Road'
  SQL
end

def haymarket_and_leith
  # Give the company and num of the services that connect stops
  # 115 and 137 ('Haymarket' and 'Leith')
  execute(<<-SQL)
    SELECT DISTINCT
      a.company, a.num
    FROM
      routes a
    JOIN
      routes b ON (a.company = b.company AND a.num = b.num)
    WHERE
      a.stop_id = 115 AND b.stop_id = 137
  SQL
end

def craiglockhart_and_tollcross
  # Give the company and num of the services that connect stops
  # 'Craiglockhart' and 'Tollcross'
  execute(<<-SQL)
    SELECT
      a.company, a.num
    FROM
      routes a
    JOIN
      routes b ON (a.company = b.company AND a.num = b.num)
    JOIN
      stops stopa ON (a.stop_id = stopa.id)
    JOIN
      stops stopb ON (b.stop_id = stopb.id)
    WHERE
      stopa.name = 'Craiglockhart' AND stopb.name = 'Tollcross'
  SQL
end

def start_at_craiglockhart
  # Give a distinct list of the stops that can be reached from 'Craiglockhart'
  # by taking one bus, including 'Craiglockhart' itself. Include the stop name,
  # as well as the company and bus no. of the relevant service.
  execute(<<-SQL)
    SELECT
      stopa.name, a.company, a.num
    FROM
      stops stopa
    JOIN
      routes a ON (a.stop_id = stopa.id)
    JOIN
      routes b ON (a.company = b.company AND a.num = b.num)
    JOIN
      stops stopb ON (b.stop_id = stopb.id)
    WHERE
      stopb.name = 'Craiglockhart'
  SQL
end

def craiglockhart_to_sighthill
  # Find the routes involving two buses that can go from Craiglockhart to
  # Sighthill. Show the bus no. and company for the first bus, the name of the
  # stop for the transfer, and the bus no. and company for the second bus.
  execute(<<-SQL)
    SELECT DISTINCT
      a.num, a.company, stopb.name, d.num, d.company
    FROM
      stops stopa
    JOIN
      routes a ON (a.stop_id = stopa.id)
    JOIN
      routes b ON (a.company = b.company AND a.num = b.num)
    JOIN
      stops stopb ON (b.stop_id = stopb.id)
    JOIN
      routes c ON (c.stop_id = stopb.id)
    JOIN
      routes d ON (d.company = c.company AND c.num = d.num)
    JOIN
      stops stopc ON (d.stop_id = stopc.id)
    WHERE
      stopa.name = 'Craiglockhart' AND stopc.name = 'Sighthill'
  SQL
end