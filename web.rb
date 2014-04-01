#!/usr/bin/env ruby

require 'rubygems'
require 'sinatra'
require 'json'
require 'pg'


# Forms a connection with the server. "$conn" takes PostGreSQL commands, 
# passing them onto the server. 
$conn = PG::connect(:host => 'ec2-54-204-44-31.compute-1.amazonaws.com', :port => 5432, :dbname => 'daka8s9502p8uo', :user => 'psczeygltqeesf', :password => 'pEETVlkA65Lq7qboYkac1WbPZZ')


# Helper function; pulls relevant metadata on all songs in a room, saving and 
# consolidating in a single JSON file. 
def getSongs(groupid) 
    res = $conn.exec("SELECT songid,song,artist,album,aurl FROM #{groupid} ORDER BY placeid").values()
    res.each do |song|
        song[0]='{"key": "' + song[0] + '"'
        song[1]='"trackname": "' + song[1] + '"'
        song[2]='"artist": "' + song[2] + '"'
        song[3]='"album": "' + song[3] + '"'
        song[4]='"albumcover": "' + song[4] + '"}'
        song = song.join(',')
    end
    json_out_str = '[]'
    if(res.length != 0)
        json_out_str = '['+ res.join(',')+']'
    end
    File.open('songs.json','w') {|f| f.write(json_out_str)}
    send_file('songs.json')
end


# Set patterns for app to call as URLs. Patterns follow a clear pattern
# listed below, generally being the root directory followed by a command and
# its options. 
    get '/create/:groupid' do
        begin 
            $conn.exec("CREATE TABLE #{params[:groupid]} (placeid integer NOT NULL, songid varchar(255), song varchar(255), artist varchar(255), album varchar(255), aurl varchar(255), PRIMARY KEY (placeid))")
            File.open('songs.json','w') {|f| f.write('[]')}
            send_file('songs.json')
        rescue PG::Error => err
            if(err.result.error_field( PG::Result::PG_DIAG_SQLSTATE ).eql? "42P07")
                getSongs(params[:groupid])
            end
        end
    end

    get '/join/:groupid' do
        begin
            getSongs(params[:groupid])
        rescue PG::Error => err
            if(err.result.error_field( PG::Result::PG_DIAG_SQLSTATE ).eql? "42P01")
                File.open('error.txt', 'w') {|f| f.write('No existing group with groupid "' + params[:groupid] + '".')}
                send_file('error.txt')
            end
        end
    end

    get '/add/:groupid/:songid/:song/:artist/:album/:aurl' do
        place = $conn.exec("SELECT count(*) FROM #{params[:groupid]}").values()[0][0]
        $conn.exec("INSERT INTO #{params[:groupid]} values (#{place}, '#{params[:songid]}', '#{params[:song]}', '#{params[:artist]}', '#{params[:album]}', '#{params[:aurl]}')")
        getSongs(params[:groupid])
    end

    get '/remove/:groupid/:placeid' do
        $conn.exec("DELETE FROM #{params[:groupid]} WHERE placeid=#{params[:placeid]}")
        getSongs(params[:groupid])
    end

    get '/leave/:groupid' do
        $conn.exec("DROP TABLE #{params[:groupid]}")
    end

    get '/listrooms' do
        File.open('tables.txt', 'w') do |f|
            tables = $conn.exec("SELECT * FROM pg_tables WHERE schemaname='public'").values()
            tables.each {|entry| entry = entry.to_s}
            f.write(tables.to_s)
        end
        send_file('tables.txt')
    end
