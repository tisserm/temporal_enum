# frozen_string_literal: true

RSpec.describe TemporalEnum do
  with_model :Book, scope: :all do
    table do |t|
      t.integer :status
      t.integer :type
    end

    model do
      enum :status, {
        proposed: 0,
        written: 1,
        published: 2
      }, temporal: true

      enum :type, {
        novel: 0,
        poetry: 1
      }
    end
  end

  let!(:book) { Book.create! }

  after(:each) do
    Book.delete_all
  end

  it "has a version number" do
    expect(TemporalEnum::VERSION).not_to be nil
  end

  it "is defined if the option is given" do
    expect(book).to respond_to(:before_proposed?)
    expect(book).to respond_to(:before_written?)
    expect(book).to respond_to(:before_published?)

    expect(book).to respond_to(:after_proposed?)
    expect(book).to respond_to(:after_written?)
    expect(book).to respond_to(:after_published?)

    expect(Book).to respond_to(:before_proposed)
    expect(Book).to respond_to(:before_written)
    expect(Book).to respond_to(:before_published)

    expect(Book).to respond_to(:after_proposed)
    expect(Book).to respond_to(:after_written)
    expect(Book).to respond_to(:after_published)
  end

  it "is not defined if the option is not given" do
    expect(book).to_not respond_to(:type_before_novel?)
    expect(book).to_not respond_to(:type_before_poetry?)

    expect(book).to_not respond_to(:type_after_novel?)
    expect(book).to_not respond_to(:type_after_poetry?)

    expect(Book).to_not respond_to(:type_before_novel)
    expect(Book).to_not respond_to(:type_before_poetry)

    expect(Book).to_not respond_to(:type_after_novel)
    expect(Book).to_not respond_to(:type_after_poetry)
  end

  it "before_status? method returns the correct value" do
    book.update(status: 0) # i.e proposed
    expect(book.before_proposed?).to be(false)
    expect(book.before_written?).to be(true)
    expect(book.before_published?).to be(true)

    book.update(status: 1) # i.e written
    expect(book.before_proposed?).to be(false)
    expect(book.before_written?).to be(false)
    expect(book.before_published?).to be(true)

    book.update(status: 2) # i.e published
    expect(book.before_proposed?).to be(false)
    expect(book.before_written?).to be(false)
    expect(book.before_published?).to be(false)
  end

  it "after_status? method returns the correct value" do
    book.update(status: 0) # i.e proposed
    expect(book.after_proposed?).to be(false)
    expect(book.after_written?).to be(false)
    expect(book.after_published?).to be(false)

    book.update(status: 1) # i.e written
    expect(book.after_proposed?).to be(true)
    expect(book.after_written?).to be(false)
    expect(book.after_published?).to be(false)

    book.update(status: 2) # i.e published
    expect(book.after_proposed?).to be(true)
    expect(book.after_written?).to be(true)
    expect(book.after_published?).to be(false)
  end

  it "before_status scope returns the correct objects" do
    book.update(status: 0) # i.e proposed
    Book.create(status: 1) # i.e written
    Book.create(status: 2) # i.e published
    expect(Book.before_proposed.count).to equal(0)
    expect(Book.before_written.count).to equal(1)
    expect(Book.before_published.count).to equal(2)
  end

  it "after_status scope returns the correct objects" do
    book.update(status: 0) # i.e proposed
    Book.create(status: 1) # i.e written
    Book.create(status: 2) # i.e published
    expect(Book.after_proposed.count).to equal(2)
    expect(Book.after_written.count).to equal(1)
    expect(Book.after_published.count).to equal(0)
  end
end
