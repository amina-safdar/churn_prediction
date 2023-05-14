"""Facilitate querying PostgreSQL databases."""

import csv
import logging
import os
import psycopg2
from psycopg2 import extensions
import tomli

with open(f"{os.getcwd()}/config.toml",
          mode="rb") as config_file:
    config = tomli.load(config_file)

QUERY_PATH = config["path"]["query"]
CSV_PATH = config["path"]["csv"]


class DatabaseContextManager:
    """
    Context manager (CM) for PostgreSQL databases using Psycopg 2 as its
    adapter. Note that the CM commits on exit. Database connection arguments
    for Manning's liveBook customer churn prediction task are provided
    in `config.toml`.
    """

    def __init__(self, db_config: dict) -> None:
        """
        Create a `DatabaseContextManager` object holding arguments required
        to connect to an existing database.
        """
        self.dbname = db_config["name"]
        self.user = db_config["user"]
        self.password = db_config["password"]
        self.host = db_config["host"]
        self.port = db_config["port"]

    def __enter__(self) -> psycopg2.extensions.cursor:
        """
        Connect to the existing database. By default, this is Manning's
        `liveBook` database. Return a cursor to the connection in order to
        execute database commands.
        """

        logging.info("Calling __enter__")
        self.conn = psycopg2.connect(dbname=self.dbname, user=self.user,
                                     password=self.password, host=self.host,
                                     port=self.port)
        self.cur = self.conn.cursor()
        return self.cur

    def __exit__(self, exc_type, exc_value, exc_trace) -> None:
        """
        Terminate Make transactions persistant by committing them to the
        database. Close the
        cursor and connection.
        """
        logging.info("Calling __exit__")
        self.conn.commit()
        self.cur.close()
        self.conn.close()


class Query:
    """
    Query class representing SQL queries for PostgreSQL database.
    Public methods include
    """

    def __init__(self, name: str, mode: str, bind_var: dict = {},
                 save_ext: str = None) -> None:
        self.name = name
        self.mode = mode
        self.bind_var = bind_var
        self.save_ext = save_ext

    def _read(self) -> str:
        query_file = f"{QUERY_PATH}/{self.name}.sql"
        with open(query_file, "r") as query_file:
            self.query = query_file.read()
            return self.query

    @staticmethod
    def _get_output(cursor: psycopg2.extensions.cursor) -> tuple[
            list[str], list[tuple]]:
        header = [i[0] for i in cursor.description]
        data = cursor.fetchall()
        return header, data

    def get_output_filepath(self):
        assert self.mode == "save", f"`{self.name}` query has 'commit' mode; there is no filepath."
        if self.save_ext:
            output_filepath = f"{CSV_PATH + self.name}_{self.save_ext}.csv"
        else:
            output_filepath = f"{CSV_PATH + self.name}.csv"
        self.output_filepath = output_filepath
        return output_filepath

    def _write_output(self, w_config: dict, header, data) -> csv.writer:
        output_filepath = self.get_output_filepath()
        with open(output_filepath, "w+", newline="") as output_file:
            output_csv = csv.writer(output_file, w_config)
            output_csv.writerow(header)
            output_csv.writerows(data)
        return output_csv

    def run(self) -> None:
        with DatabaseContextManager(config["db"]) as cursor:
            self._read()
            cursor.execute(self.query, self.bind_var)
            if self.mode == "commit":
                self.conn.commit()
            elif self.mode == "save":
                header, data = self._get_output(cursor)
                self.get_output_filepath()
                self._write_output(config["csv_writer"],
                                   header=header, data=data)


d = ['LivebookLogin',
     'ProductTocLivebookLinkOpened',
     'ReadingOpenChapter',
     'FreeContentCheckout',
     'HighlightCreated',
     'ReadingFreePreview',
     'EBookDownloaded',
     'FirstManningAccess',
     'FirstLivebookAccess',
     'ReadingOwnedBook']
for x in d:
    t = {
        'from_yyyy-mm-dd': '2019-12-01',
        'to_yyyy-mm-dd': '2020-06-01',
        'event_type': x
    }
    q = Query("events_per_day", "save", bind_var=t, save_ext=x)
    q.run()
